import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoURL: URL
    
    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .onAppear {
                // 自动播放视频
                AVPlayer(url: videoURL).play()
            }
    }
}