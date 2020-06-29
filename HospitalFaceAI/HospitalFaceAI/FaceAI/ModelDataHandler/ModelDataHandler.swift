//
//  ModelDataHandler.swift
//  HospitalFaceAI
//
//  Created by song on 2019/9/24.
//  Copyright © 2019 song. All rights reserved.
//

import CoreImage
import TensorFlowLite
import UIKit

typealias FileInfo = (name: String, extension: String)
struct Result {
    let inferenceTime: Double
    let faceboxes: [FaceBox]
}

struct FaceBox {
    let x_min: Float
    let y_min: Float
    let x_max: Float
    let y_max: Float
}

//160 * 160
enum FaceNet {
    //facecheck160_160
    static let modelInfo: FileInfo = (name: "facecheck160_160", extension: "tflite")
}

class ModelDataHandler: NSObject {
    let threadCount: Int // 线程使用条数
    
    let batchSize = 1 // 数据分为多少批次喂给模型，此处为1次全部输入
    let inputChannels = 3 // 图片像素对应的3个通道R、G、B
    let inputWidth = 160 // 图片宽度像素值
    let inputHeight = 160 // 图片高度像素值
    
    private var interpreter: Interpreter // 模型解释器
    private let alphaComponent = (baseOffset: 4, moduloRemainder: 0)
    
    init?(modelFileInfo: FileInfo,threadCount: Int = 1) {
        let modelFilename = modelFileInfo.name
        
        guard let modelPath = Bundle.main.path(forResource: modelFilename, ofType: modelFileInfo.extension) else {
            print("Failed to load the model file with name: \(modelFilename).\(modelFileInfo.extension)")
            return nil
        }
        self.threadCount = threadCount
        var options = InterpreterOptions()
        options.threadCount = threadCount
        do {
            interpreter = try Interpreter(modelPath:modelPath, options: options)
            try interpreter.allocateTensors()
        }catch let error {
            print("Failed to create the interpreter with error: \(error.localizedDescription)")
            return nil
        }
        
        super.init()
    }
    
    //this model just return only one biggest face
    func runModel(onFrame pixelBuffer: CVPixelBuffer) -> Result?{
        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
        assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
            sourcePixelFormat == kCVPixelFormatType_32BGRA ||
            sourcePixelFormat == kCVPixelFormatType_32RGBA)
        
        
        let imageChannels = 4
        assert(imageChannels >= inputChannels)
        
        // Crops the image to the biggest square in the center and scales it down to model dimensions.
//        let scaledSize = CGSize(width: inputWidth, height: inputHeight)
//        let test = resizePixelBuffer(pixelBuffer, width: inputWidth, height: inputHeight)
        
        // 根据输入图片的像素值，把宽高转换为模型需要的宽高值，此处必须保证喂入数据和模型要求数据一致
        guard let thumbnailPixelBuffer = resizePixelBuffer(pixelBuffer, width: inputWidth, height: inputHeight) else {
            return nil
        }
        
        let interval: TimeInterval
        //根据模型，这里可以有很多输出
        let outputTensor0: Tensor //输出数据1
        let outputTensor1: Tensor //输出数据2
//        let outputTensor2: Tensor
        do {
            let inputTensor = try interpreter.input(at: 0)
            
            guard let rgbData = rgbDataFromBuffer(
                thumbnailPixelBuffer,
                byteCount: batchSize * inputWidth * inputHeight * inputChannels,
                isModelQuantized: inputTensor.dataType == .uInt8
                ) else {
                    print("Failed to convert the image buffer to RGB data.")
                    return nil
            }
            
            try interpreter.copy(rgbData, toInputAt: 0)
            let startDate = Date()
            try interpreter.invoke()
            interval = Date().timeIntervalSince(startDate) * 1000
            outputTensor0 = try interpreter.output(at: 0)
            outputTensor1 = try interpreter.output(at: 1)
        }catch let error {
            print("Failed to invoke the interpreter with error: \(error.localizedDescription)")
            return nil
        }
        
        var ouputresults0: [Float]
        var ouputresults1: [Float]
        ouputresults0 = [Float32](unsafeData: outputTensor0.data) ?? []
        ouputresults1 = [Float32](unsafeData: outputTensor1.data) ?? []
        var faceBoxs = [Float32](repeating: 0, count: 4)//[Float]()
        //对应后处理 C++ 编写的后处理
        getDetection(&ouputresults0, &ouputresults1, Int32(inputWidth), Int32(inputHeight), 0.7, &faceBoxs)
        //结果 只会返回一个人脸 faceBoxs 4个点 对应 左上。右下
        //筛选不合格的数据
        if faceBoxs[0] > 0.0 && faceBoxs[1] > 0.0 && faceBoxs[2] > 0.0 && faceBoxs[3] > 0.0  {
            //将合格数据转换成我们需要的数据结构供程序使用
            let resultFace = FaceBox(x_min: faceBoxs[0], y_min: faceBoxs[1], x_max: faceBoxs[2], y_max: faceBoxs[3])
            let result = Result(inferenceTime: interval, faceboxes: [resultFace])
            return result
        }else {
            return nil
        }
    }
    
    func runModelWithImage(onImage image: UIImage) -> Result?{
        let imageBuffer = image.pixelBuffer(width: 160, height: 160)
        guard let resultBuffer = imageBuffer else {
            print("获取 imageBuffer 失败")
            return nil
        }
        return runModel(onFrame: resultBuffer)
    }
    
    
    
    /// Returns the RGB data representation of the given image buffer with the specified `byteCount`.
    ///
    /// - Parameters
    ///   - buffer: The pixel buffer to convert to RGB data.
    ///   - byteCount: The expected byte count for the RGB data calculated using the values that the
    ///       model was trained on: `batchSize * imageWidth * imageHeight * componentsCount`.
    ///   - isModelQuantized: Whether the model is quantized (i.e. fixed point values rather than
    ///       floating point values).
    /// - Returns: The RGB data representation of the image buffer or `nil` if the buffer could not be
    ///     converted.
    private func rgbDataFromBuffer(
        _ buffer: CVPixelBuffer,
        byteCount: Int,
        isModelQuantized: Bool
        ) -> Data? {
        CVPixelBufferLockBaseAddress(buffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(buffer, .readOnly) }
        guard let mutableRawPointer = CVPixelBufferGetBaseAddress(buffer) else {
            return nil
        }
        let count = CVPixelBufferGetDataSize(buffer)
        let bufferData = Data(bytesNoCopy: mutableRawPointer, count: count, deallocator: .none)
        var rgbBytes = [UInt8](repeating: 0, count: byteCount)
        var index = 0
        for component in bufferData.enumerated() {
            let offset = component.offset
            let isAlphaComponent = (offset % alphaComponent.baseOffset) == alphaComponent.moduloRemainder
            guard !isAlphaComponent else { continue }
            rgbBytes[index] = component.element
            index += 1
        }
        if isModelQuantized { return Data(bytes: rgbBytes) }
        return Data(copyingBufferOf: rgbBytes.map { Float($0) })
    }

}


// MARK: - Extensions

extension Data {
    /// Creates a new buffer by copying the buffer pointer of the given array.
    ///
    /// - Warning: The given array's element type `T` must be trivial in that it can be copied bit
    ///     for bit with no indirection or reference-counting operations; otherwise, reinterpreting
    ///     data from the resulting buffer has undefined behavior.
    /// - Parameter array: An array with elements of type `T`.
    init<T>(copyingBufferOf array: [T]) {
        self = array.withUnsafeBufferPointer(Data.init)
    }
}

extension Array {
    /// Creates a new array from the bytes of the given unsafe data.
    ///
    /// - Warning: The array's `Element` type must be trivial in that it can be copied bit for bit
    ///     with no indirection or reference-counting operations; otherwise, copying the raw bytes in
    ///     the `unsafeData`'s buffer to a new array returns an unsafe copy.
    /// - Note: Returns `nil` if `unsafeData.count` is not a multiple of
    ///     `MemoryLayout<Element>.stride`.
    /// - Parameter unsafeData: The data containing the bytes to turn into an array.
    init?(unsafeData: Data) {
        guard unsafeData.count % MemoryLayout<Element>.stride == 0 else { return nil }
        #if swift(>=5.0)
        self = unsafeData.withUnsafeBytes { .init($0.bindMemory(to: Element.self)) }
        #else
        self = unsafeData.withUnsafeBytes {
            .init(UnsafeBufferPointer<Element>(
                start: $0,
                count: unsafeData.count / MemoryLayout<Element>.stride
            ))
        }
        #endif  // swift(>=5.0)
    }
}
