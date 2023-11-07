//
//  ZoomImageVC.swift
//  ConsignItAway
//
//  Created by Apple on 02/06/22.
//

import UIKit
import SDWebImage
class ZoomImageVC: BaseClassVC {
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.maximumZoomScale = 4
            scrollView.minimumZoomScale = 1
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var imageView : UIImageView!
    var imageString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
                self.imageView.setImage(link: self.imageString)
        }
    }
    func initUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tapGesture.numberOfTapsRequired = 2
        imageView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(tapGesture)
    }
    @objc func handleDoubleTap(gestureRecognizer: UIGestureRecognizer) {
        if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
}
extension ZoomImageVC: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
