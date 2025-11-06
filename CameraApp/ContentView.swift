//
//  ContentView.swift
//  CameraApp
//
//  Created by Kare on 11/6/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var showingCamera = false
    @State private var capturedImage: UIImage?
    @State private var videoURL: URL?
    @State private var selectedMediaType: MediaType = .photo
    @State private var showingVideoPlayer = false
    
    var body: some View {
        VStack(spacing: 30) {
            // 模式选择器
            Picker("选择模式", selection: $selectedMediaType) {
                Text("拍照").tag(MediaType.photo)
                Text("录像").tag(MediaType.video)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 40)
            
            // 媒体预览区域
            Group {
                if selectedMediaType == .photo {
                    if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .cornerRadius(12)
                    } else {
                        placeholderView
                    }
                } else {
                    if let videoURL = videoURL {
                        VStack {
                            placeholderView
                                .overlay(
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                )
                                .onTapGesture {
                                    showingVideoPlayer = true
                                }
                            
                            Text("点击播放视频")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        placeholderView
                    }
                }
            }
            .frame(height: 300)
            .padding(.horizontal)
            
            // 操作按钮
            VStack(spacing: 15) {
                Button(action: {
                    showingCamera = true
                }) {
                    HStack {
                        Image(systemName: selectedMediaType == .photo ? "camera" : "video")
                        Text(selectedMediaType == .photo ? "拍摄照片" : "录制视频")
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                
                // 清除按钮
                if capturedImage != nil || videoURL != nil {
                    Button("清除内容") {
                        capturedImage = nil
                        videoURL = nil
                    }
                    .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.vertical)
        .sheet(isPresented: $showingCamera) {
            CameraView(
                capturedImage: $capturedImage,
                videoURL: $videoURL,
                mediaType: selectedMediaType
            )
        }
        .sheet(isPresented: $showingVideoPlayer) {
            if let videoURL = videoURL {
                VideoPlayerView(videoURL: videoURL)
            }
        }
    }
    
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .overlay(
                VStack(spacing: 10) {
                    Image(systemName: selectedMediaType == .photo ? "photo" : "video")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("\(selectedMediaType.description)将显示在这里")
                        .foregroundColor(.secondary)
                }
            )
    }
}

#Preview {
    ContentView()
}
