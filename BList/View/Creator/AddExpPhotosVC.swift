//
//  AddExpPhotosVC.swift
//  BList
//
//  Created by iOS Team on 27/05/22.
//

import UIKit
import AVKit
class AddExpPhotosVC: BaseClassVC {
    @IBOutlet weak var collectionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var collectionView: myCollectionView!
    @IBOutlet weak var img_cover: UIImageView!
    @IBOutlet weak var view_cover: CustomDashedView!
    @IBOutlet weak var deleteCoverPic: UIButton!
    @IBOutlet weak var coverPhotoLbl: UILabel!
    @IBOutlet weak var addCoverPhotoLbl: UILabel!
    var images = [UIImage]()
    weak var creatorVM : CreatorViewModel!
    weak var delegate : changeModelType?
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapAction(_:)))
        view_cover.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.setupUI()
        }
    }
    func setupUI() {
        if let coverPic = creatorVM.coverPhoto {
            view_cover.dashColor = .clear
            img_cover.image = coverPic
            coverPhotoLbl.isHidden = false
            deleteCoverPic.isHidden = false
            addCoverPhotoLbl.isHidden = true
        } else {
            view_cover.dashColor = UIColor(named: "AppOrange")!
            coverPhotoLbl.isHidden = true
            deleteCoverPic.isHidden = true
            addCoverPhotoLbl.isHidden = false
        }
        view_cover.layoutSubviews()
        if creatorVM.media.count > 0 {
            collectionView.isHidden = false
            collectionView.reloadData {
                self.collectionHeightConst.constant =  self.creatorVM.media.count < 4 ? 110 : 220
            }
        } else {
            collectionView.isHidden = true
        }
    }
    @objc func viewTapAction(_ sender: UITapGestureRecognizer) {
        let share = CameraHandler.shared
        share.showActionSheet(preference: .onlyPhotos, vc: self)
        share.imagePickedBlock = { [weak self] img in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.creatorVM.coverPhoto = img
                self.view_cover.dashColor = .clear
                self.view_cover.layoutSubviews()
                self.img_cover.image = img
                self.deleteCoverPic.isHidden = false
                self.coverPhotoLbl.isHidden = false
            }
        }
    }
    func setupData() {
        self.view_cover.isHidden = false
    }
    override func actionBack(_ sender: Any) {
        self.delegate?.changeModel()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func openCamera(_ sender : UIButton){
        let share = CameraHandler.shared
        share.showActionSheet(preference: .photos_Videos, vc: self)
        share.mediaURLPickedBlock = { [weak self] mediaURL in
            guard let self = self else {return}
            let media = Media(mediaType: "Video", image: nil, video: mediaURL)
            if let index = self.creatorVM.media.firstIndex(where: {$0.mediaType == "Video"}) {
                self.creatorVM.media.remove(at: index)
            }
            self.creatorVM.media.append(media)
            DispatchQueue.main.async {
                self.collectionView.isHidden = false
                self.collectionView.reloadData {
                    self.collectionHeightConst.constant =  self.creatorVM.media.count < 4 ? 110 : 220
                }
            }
        }
        share.imagePickedBlock = { [weak self] img in
            guard let self = self else {return}
            let media = Media(mediaType: "Image", image: img, video: nil)
            self.creatorVM.media.append(media)
            self.collectionView.isHidden = false
            self.collectionView.reloadData {
                self.collectionHeightConst.constant =  self.creatorVM.media.count < 4 ? 110 : 220
            }
        }
    }
    @IBAction func deleteCoverImage(_ sender : UIButton){
        DispatchQueue.main.async {
            self.img_cover.image = nil
            self.view_cover.dashColor = UIColor(named: "AppOrange")!
            self.view_cover.layoutSubviews()
            self.creatorVM.coverPhoto = nil
            self.deleteCoverPic.isHidden = true
            self.coverPhotoLbl.isHidden = true
        }
    }
    @IBAction func submit(_ sender : UIButton){
        if self.creatorVM.media.count == 0 && img_cover.image == nil{
            self.showErrorMessages(message: "Please upload cover image atleast")
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            vc.creatorVM = creatorVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
        // ChooseLanguageVC
    }
    
}


extension AddExpPhotosVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creatorVM.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if creatorVM.media[indexPath.row].mediaType == "Image" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as? PhotosCollectionCell else {return .init()}
            if indexPath.row < 6{
                cell.stackView.isHidden = true
                cell.imgView.backgroundColor = .cyan
                cell.deleteBtn.isHidden = false
                cell.vick_back.isHidden = true
            } else {
                cell.vick_back.isHidden = false
                cell.deleteBtn.isHidden = true
                cell.imgView.backgroundColor = AppColor.app252634
                cell.stackView.isHidden = false
            }
            cell.imgView.image = creatorVM.media[indexPath.row].image
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteAction(_ :)), for: .touchUpInside)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCell else {return .init()}
            cell.addVideo(url: creatorVM.media[indexPath.row].video)
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteAction(_ :)), for: .touchUpInside)
            NotificationCenter.default.addObserver(self, selector: #selector(replayAction(_:)), name: .AVPlayerItemDidPlayToEndTime, object: cell.avplayer?.currentItem)
            return cell
        }
        
    }
    @objc func replayAction(_ sender: NSNotification) {
        if let index = creatorVM.media.firstIndex(where: {$0.mediaType == "Video"}), let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? VideoCell{
            cell.playBtn.isSelected.toggle()
            cell.avplayer?.seek(to: .zero)
        }
    }
    @objc func deleteAction(_ sender : UIButton){
        
        self.creatorVM.media.remove(at: sender.tag)
        if creatorVM.media.count == 0{
            self.collectionView.isHidden = true
        }
        else{
            self.collectionView.reloadData {
                self.collectionHeightConst.constant =  self.creatorVM.media.count < 4 ? 110 : 220
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.frame.size.width - 15) / 3
        return CGSize(width: width, height: 110)
    }
}

class PhotosCollectionCell: UICollectionViewCell {
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var vick_back: UIView!
    
}

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var avplayerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    var avplayer: AVPlayer?
    var avplayerLayer: AVPlayerLayer?
    var observer1: NSKeyValueObservation?
    override func layoutSubviews() {
        super.layoutSubviews()
        if avplayerLayer != nil {
            avplayerLayer!.frame = avplayerView.bounds
        }
    }
    @IBAction func playBtnAction(_ sender:UIButton) {
        sender.isSelected.toggle()
        sender.isSelected ? avplayer?.play() : avplayer?.pause()
    }
    func addVideo(url: URL?) {
        if let url = url {
            avplayer = AVPlayer(url: url)
            avplayerLayer = AVPlayerLayer(player: avplayer)
            if let avplayerLayer = avplayerLayer {
                avplayerView.layer.sublayers?.removeAll()
                avplayerView.layer.addSublayer(avplayerLayer)
                avplayerLayer.frame = avplayerView.bounds
                layoutSubviews()
            }
            avplayer?.volume = 0
            observer1 = avplayer?.observe(\.status, options:  [.new, .old], changeHandler: { (playerItem, change) in
                DispatchQueue.main.async {
                    if playerItem.status == .readyToPlay {
                        print("Video is ready to play...")
                    } else if playerItem.status == .failed || playerItem.status == .unknown {
                        print("Video failed")
                    }
                }
            })
        }
    }
}

struct Media {
    let mediaType: String?
    let image: UIImage?
    let video: URL?
}
