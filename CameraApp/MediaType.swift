import Foundation

enum MediaType {
    case photo
    case video
    
    var description: String {
        switch self {
        case .photo: return "照片"
        case .video: return "视频"
        }
    }
}