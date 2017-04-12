//
//  MessageViewController.swift
//  Socket_Chat
//
//  Created by Developer88 on 4/6/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import CoreLocation
import Photos
import DKImagePickerController
import SocketRocket

class MessageViewController: JSQMessagesViewController, SRWebSocketDelegate {
    
    let pickerController = DKImagePickerController()
    let locationManager = CLLocationManager()
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        self.senderId = "987654321"
        self.senderDisplayName = "Master"
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 25
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        messages.append(message!)
        self.collectionView.reloadData()
        do {
            var dic:[String:Any]!
            dic = ["senderId":123456789,"message":"hello","recieverId":987654321,"type":"message"]
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            Constants.websocket.send(NSData(data: jsonData))
        } catch {
            print(error.localizedDescription)
        }
        self.finishSendingMessage(animated : true)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        cell.textView?.textColor = UIColor.black
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Send Photo/Video", style: .default) { (action) in
            /**
             *  Create fake photo
             */
            self.addphoto()
            
        }
        
        let locationAction = UIAlertAction(title: "Send location", style: .default) { (action) in
            /**
             *  Add fake location
             */
            let locationItem = self.buildLocationItem()
            
            self.addMedia(locationItem)
        }
        
        let videoAction = UIAlertAction(title: "Send video", style: .default) { (action) in
            /**
             *  Add fake video
             */
            let videoItem = self.buildVideoItem()
            
            self.addMedia(videoItem)
        }
        
        let audioAction = UIAlertAction(title: "Send audio", style: .default) { (action) in
            /**
             *  Add fake audio
             */
            let audioItem = self.buildAudioItem()
            
            self.addMedia(audioItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(locationAction)
        sheet.addAction(videoAction)
        sheet.addAction(audioAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)

    }
    
    func buildVideoItem() -> JSQVideoMediaItem {
        let videoURL = URL(fileURLWithPath: "file://")
        
        let videoItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
        
        return videoItem!
    }
    
    func buildAudioItem() -> JSQAudioMediaItem {
        let sample = Bundle.main.path(forResource: "jsq_messages_sample", ofType: "m4a")
        let audioData = try? Data(contentsOf: URL(fileURLWithPath: sample!))
        
        let audioItem = JSQAudioMediaItem(data: audioData)
        
        return audioItem
    }
    
    func buildLocationItem() -> JSQLocationMediaItem {
        let ferryBuildingInSF = locationManager.location
        
        let locationItem = JSQLocationMediaItem()
        locationItem.setLocation(ferryBuildingInSF) {
            self.collectionView!.reloadData()
        }
        
        return locationItem
    }
    
    func addMedia(_ media:JSQMediaItem) {
        let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: media)
        
        self.messages.append(message!)
        
        //Optional: play sent sound
        
        self.finishSendingMessage(animated: true)
    }
    
    func addphoto(){
//        let allAssets = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: nil)
//        var evenAssetIds = [String]()
//        
//        allAssets.enumerateObjects({ (asset, idx, stop) -> Void in
//            if idx % 2 == 0 {
//                evenAssetIds.append(asset.localIdentifier)
//            }
//        })
//        
//        let vc = BSImagePickerViewController()
//        
//        
//        bs_presentImagePickerController(vc, animated: true,
//                                        select: { (asset: PHAsset) -> Void in
//                                            print("Selected: \(asset)")
//        }, deselect: { (asset: PHAsset) -> Void in
//            print("Deselected: \(asset)")
//        }, cancel: { (assets: [PHAsset]) -> Void in
//            print("Cancel: \(assets)")
//        }, finish: { (assets: [PHAsset]) -> Void in
//            for i in assets {
//                i.requestContentEditingInput(with: nil, completionHandler: { (asset, info) in
//                    let imageURL = asset?.fullSizeImageURL
//                    let item = JSQPhotoMediaItem()
//                    do {
//                        let data = try Data.init(contentsOf: imageURL!)
//                        item.image = UIImage(data: data)
//                    } catch {
//                        print("error")
//                    }
//                    self.addMedia(item)
//                })
//            }
//
//        }, completion: nil)
//        self.collectionView.reloadData()
        self.present(pickerController, animated: true) {}
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            for i in assets {
                if(i.isVideo) {
                    i.fetchAVAsset(nil, completeBlock: { (data, info) in
                        if let urlAsset = data as? AVURLAsset {
                        let videoItem = JSQVideoMediaItem(fileURL: urlAsset.url, isReadyToPlay: true)
                        self.addMedia(videoItem!)
                        }
                    })
                    self.collectionView.reloadData()
                } else {
                i.fetchImageDataForAsset(true, completeBlock: { (data, info) in
                    var image: UIImage?
                    if let data = data {
                        image = UIImage(data: data)
                        let photoItem = JSQPhotoMediaItem(image: image)
                        self.addMedia(photoItem!)
                    }
                })
            }
        }

        }
    }

    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("Code: \(code)\nReason: \(reason)")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let dic = convertToDictionary(text: message as! String)
        print(dic!)
        do {
            var dic1:[String:Any]!
            var jsonData: Data!
            switch dic1!["type"] as! String {
                case "error":
                
                break
                case "authErr":
                
                break
                case "connected":
                break
                case "history":
                    
                dic1 = ["senderId":123456789,"message":"hello","recieverId":987654321,"type":"readMsgAck"]
                jsonData = try JSONSerialization.data(withJSONObject: dic1, options: .prettyPrinted)
                Constants.websocket.send(NSData(data: jsonData))
                break
                case "msgAck":
                
                break
                case "message":
                let message = JSQMessage(senderId: dic!["author"] as! String, senderDisplayName: "Kt", date: Date(), text: dic!["text"] as! String)
                self.messages.append(message!)
                collectionView.reloadData()
                
                break
                case "readMsgAck":
                
                break
                default: break
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
