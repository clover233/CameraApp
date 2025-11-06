//
//  CameraView..swift
//  CameraApp
//
//  Created by Kare on 11/6/25.
//

import SwiftUI
import UIKit
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Binding var videoURL: URL?
    var mediaType: MediaType
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        
        // 检查设备是否支持相机
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return picker
        }
        
        picker.sourceType = .camera
        
        // 根据媒体类型设置
        switch mediaType {
        case .photo:
            picker.mediaTypes = ["public.image"]
            picker.cameraCaptureMode = .photo
        case .video:
            picker.mediaTypes = ["public.movie"]
            picker.cameraCaptureMode = .video
            picker.videoQuality = .typeHigh
            
            // 设置视频最大时长（可选）
            picker.videoMaximumDuration = 30.0 // 30秒
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        // 处理媒体捕获完成
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            switch parent.mediaType {
            case .photo:
                // 处理照片
                if let image = info[.originalImage] as? UIImage {
                    parent.capturedImage = image
                }
                
            case .video:
                // 处理视频
                if let videoURL = info[.mediaURL] as? URL {
                    parent.videoURL = videoURL
                    
                    // 可选：将视频保存到相册
                    // UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
                }
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        // 处理用户取消
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
