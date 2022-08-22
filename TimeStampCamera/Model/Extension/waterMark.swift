//
//  waterMark.swift
//  TimeStampCamera
//
//  Created by USER on 19/05/22.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation
import Photos

enum QUWatermarkPosition {
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
    case Default
}

class QUWatermarkManager: NSObject {
    
    func watermark(video videoAsset:AVAsset, watermarkText text : String, saveToLibrary flag : Bool, watermarkPosition position : QUWatermarkPosition, completion : ((_ status : AVAssetExportSession.Status?, _ session: AVAssetExportSession?, _ outputURL : URL?) -> ())?) {
        self.watermark(video: videoAsset, watermarkText: text, imageName: nil, saveToLibrary: flag, watermarkPosition: position) { (status, session, outputURL) -> () in
            completion!(status, session, outputURL)
        }
    }
    
    func watermark(video videoAsset:AVAsset, imageName name : String, saveToLibrary flag : Bool, watermarkPosition position : QUWatermarkPosition, completion : ((_ status : AVAssetExportSession.Status?, _ session: AVAssetExportSession?, _ outputURL : URL?) -> ())?) {
        self.watermark(video: videoAsset, watermarkText: nil, imageName: name, saveToLibrary: flag, watermarkPosition: position) { (status, session, outputURL) -> () in
            completion!(status, session, outputURL)
        }
    }
    
    private func watermark(video videoAsset:AVAsset, watermarkText text : String!, imageName name : String!, saveToLibrary flag : Bool, watermarkPosition position : QUWatermarkPosition, completion : ((_ status : AVAssetExportSession.Status?, _ session: AVAssetExportSession?, _ outputURL : URL?) -> ())?) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            let mixComposition = AVMutableComposition()
            
            let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let clipVideoTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
            do {
                try compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: clipVideoTrack, at: CMTime.zero)
            }
            catch {
                print(error.localizedDescription)
            }
            
            let videoSize = clipVideoTrack.naturalSize
            
            let parentLayer = CALayer()
            let videoLayer = CALayer()
            parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            parentLayer.addSublayer(videoLayer)
            
            if text != nil {
                let titleLayer = CATextLayer()
                titleLayer.backgroundColor = UIColor.red.cgColor
                titleLayer.string = text
                titleLayer.font = "Helvetica" as CFTypeRef
                titleLayer.fontSize = 15
                titleLayer.alignmentMode = CATextLayerAlignmentMode.center
                titleLayer.bounds = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
                parentLayer.addSublayer(titleLayer)
            } else if name != nil {
                let watermarkImage = UIImage(named: name)
                let imageLayer = CALayer()
                imageLayer.contents = watermarkImage?.cgImage
                
                var xPosition : CGFloat = 0.0
                var yPosition : CGFloat = 0.0
                let imageSize : CGFloat = 57.0
                
                switch (position) {
                case .TopLeft:
                    xPosition = 0
                    yPosition = 0
                    break
                case .TopRight:
                    xPosition = videoSize.width - imageSize
                    yPosition = 0
                    break
                case .BottomLeft:
                    xPosition = 0
                    yPosition = videoSize.height - imageSize
                    break
                case .BottomRight, .Default:
                    xPosition = videoSize.width - imageSize
                    yPosition = videoSize.height - imageSize
                    break
                }
                
                
                imageLayer.frame = CGRect(x: xPosition, y: yPosition, width: imageSize, height: imageSize)
                imageLayer.opacity = 0.65
                parentLayer.addSublayer(imageLayer)
            }
            
            let videoComp = AVMutableVideoComposition()
            videoComp.renderSize = videoSize
            videoComp.frameDuration = CMTimeMake(value: 1, timescale: 30)
            videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: mixComposition.duration)
            _ = mixComposition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
            
            let layerInstruction = self.videoCompositionInstructionForTrack(track: compositionVideoTrack!, asset: videoAsset)
            
            instruction.layerInstructions = [layerInstruction]
            videoComp.instructions = [instruction]
            
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let date = dateFormatter.string(from: Date())
            let url = URL(fileURLWithPath: documentDirectory).appendingPathComponent("watermarkVideo-\(date).mov")
            
            let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
            exporter?.outputURL = url
            exporter?.outputFileType = AVFileType.mov
            exporter?.shouldOptimizeForNetworkUse = true
            exporter?.videoComposition = videoComp
            
            exporter?.exportAsynchronously() {
                DispatchQueue.main.async {
                    
                    if exporter?.status == AVAssetExportSession.Status.completed {
                        let outputURL = exporter?.outputURL
                        if flag {
                            // Save to library
                            //                            let library = ALAssetsLibrary()
                            
                            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputURL!.path) {
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL!)
                                }) { saved, error in
                                    if saved {
                                        completion!(AVAssetExportSession.Status.completed, exporter, outputURL)
                                    }
                                }
                            }
                            
                            //                            if library.videoAtPathIs(compatibleWithSavedPhotosAlbum: outputURL) {
                            //                                library.writeVideoAtPathToSavedPhotosAlbum(outputURL,
                            //                                                                           completionBlock: { (assetURL:NSURL!, error:NSError!) -> Void in
                            //
                            //                                                                            completion!(AVAssetExportSessionStatus.Completed, exporter, outputURL)
                            //                                })
                            //                            }
                        } else {
                            completion!(AVAssetExportSession.Status.completed, exporter, outputURL)
                        }
                        
                    } else {
                        // Error
                        completion!(exporter?.status, exporter, nil)
                    }
                }
            }
        }
    }
    
    
    private func orientationFromTransform(transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
    
    private func videoCompositionInstructionForTrack(track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform: transform)
        
        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
        if assetInfo.isPortrait {
            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor),
                                     at: CMTime.zero)
        } else {
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.width / 2))
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                let windowBounds = UIScreen.main.bounds
                let yFix = assetTrack.naturalSize.height + windowBounds.height
                let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
            }
            instruction.setTransform(concat, at: CMTime.zero)
        }
        return instruction
    }
}
