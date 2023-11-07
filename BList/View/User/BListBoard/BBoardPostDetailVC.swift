//
//  BBoardPostDetailVC.swift
//  BList
//
//  Created by iOS Team on 12/05/22.
//

import UIKit

class BBoardPostDetailVC: BaseClassVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var commentTF: AnimatedBindingText!{
        didSet{
            commentTF.bind { [weak self] in
                self?.userVM.replyComment.value = $0
            }
        }
    }
    @IBOutlet weak var userNameLbl      : UILabel!
    @IBOutlet weak var userImg          : UIImageView!
    @IBOutlet weak var postContent      : UILabel!
    @IBOutlet weak var postImg          : UIImageView!
    @IBOutlet weak var timeLbl          : UILabel!
    @IBOutlet weak var likeCountLbl     : UILabel!
    @IBOutlet weak var disLikeCountLbl  : UILabel!
    @IBOutlet weak var commentCountLbl  : UILabel!
    @IBOutlet weak var smileImg         : UIImageView!
    @IBOutlet weak var sadImg           : UIImageView!
    @IBOutlet weak var commentTblView   : UITableView!
    @IBOutlet weak var likeSV           : UIStackView!
    @IBOutlet weak var disLikeSV        : UIStackView!
    @IBOutlet weak var userImgBtn       : UIButton!
    // MARK: - PROPERTIES
    weak var userVM: UserViewModel!
    var postDetails: postDetails?
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: userVM)
        setUpScreenContent()
        userVM.getPostComments(postID: postDetails?.id ?? "")
        userVM.didFinishFetch = { [weak self](apiType) in
            guard let self = self else{return}
            switch apiType{
            case .getPostComments,.ReplyComment:
                if self.userVM.postComments.count > 0{
                    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.commentTblView.contentSize.width, height: 50))
                    let lbl = UILabel(frame: CGRect(x: 20, y: 0, width: headerView.frame.width-40, height: 50))
                    lbl.font = UIFont.cabin_Bold(size: 18)
                    lbl.text = "All Comments (\(self.userVM.postComments.count))"
                    headerView.addSubview(lbl)
                    self.commentTblView.tableHeaderView = headerView
                    self.commentCountLbl.attributedText = createAttributedStr(text1: "Comments  ", text2: "(\(self.userVM.postComments.count))", font1: .cabin_Regular(size: 10), font2: .cabin_SemiBold(size: 10),textColor1: UIColor(named: "#C1C1C1")!,textColor2: .black)
                }
                self.commentTblView.reloadData()
            case .LikeComment, .DisLikeComment:
                break
            default:
                break
            }
        }
        addGesture(for: [likeSV,disLikeSV])
    }
    func setUpScreenContent(){
        userNameLbl.text = postDetails?.name ?? ""
        let userImgURL = BaseURLs.userImgURL.rawValue + (postDetails?.image ?? "")
        userImg.setImage(link: userImgURL)
        let postImgURL = BaseURLs.postImgURL.rawValue + (postDetails?.postImage ?? "")
        postImg.setImage(link: postImgURL)
        postContent.text = postDetails?.postContent ?? ""
        if let createDate = postDetails?.createdAt, let date = DateConvertor.shared.convert(dateInString: createDate, from: .yyyyMMddHHmmss, to: .yyyyMMddHHmmss).date, #available(iOS 13.0, *){
            timeLbl.text = date.timeAgoDisplay()
        }
        else{
            timeLbl.text = ""
        }
        userImgBtn.setImage(userImg.image, for: .normal)
        setUpLikeUnLikeViews(yourLike: postDetails?.yourLike)
        commentCountLbl.attributedText = createAttributedStr(text1: "Comments  ", text2: "(\(postDetails?.commentsCount ?? 0))", font1: .cabin_Regular(size: 10), font2: .cabin_SemiBold(size: 10),textColor1: UIColor(named: "#C1C1C1")!,textColor2: .black)//"Comments(\(postDetails?.commentsCount ?? 0))"
        
    }
    func addGesture(for views: [UIStackView]){
        for view in views{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeOrDislikeTapAction(_:)))
            view.addGestureRecognizer(tapGesture)
        }
    }
    func setUpLikeUnLikeViews(yourLike: String?){
        if yourLike == "1"{
            smileImg.image = UIImage(named: "smile")
            sadImg.image = UIImage(named: "sad_unsel")
        }
        else if yourLike == "2"{
            smileImg.image = UIImage(named: "smile_unsel")
            sadImg.image = UIImage(named: "sad")
        }
        else{
            smileImg.image = UIImage(named: "smile_unsel")
            sadImg.image = UIImage(named: "sad_unsel")
        }
        likeCountLbl.text = "\(postDetails?.likesCount ?? 0)"
        disLikeCountLbl.text = "\(postDetails?.dislikesCount ?? 0)"
    }
    @objc func likeOrDislikeTapAction(_ sender: UITapGestureRecognizer){
        let yourLike = postDetails?.yourLike
        let likesCount = postDetails?.likesCount ?? 0
        let disLikesCount = postDetails?.dislikesCount ?? 0
        if sender.view?.tag == 0{
            // LIKE
            userVM.likeComment(postID: postDetails?.id ?? "0")
            postDetails?.yourLike = (yourLike == "0" || yourLike == "2") ? "1" : "0"
            if yourLike == "0"{
                postDetails?.likesCount = likesCount + 1
            }
            else if yourLike == "1"{
                postDetails?.likesCount = likesCount > 0 ? likesCount-1 : 0
            }
            else{
                postDetails?.dislikesCount = disLikesCount > 0 ? disLikesCount-1 : 0
                postDetails?.likesCount = likesCount + 1
            }
        }
        else{
            // DISLIke
            userVM.disLikeComment(postID: postDetails?.id ?? "0")
            postDetails?.yourLike = (yourLike == "0" || yourLike == "1") ? "2" : "0"
            if yourLike == "0"{
                postDetails?.dislikesCount = disLikesCount + 1
            }
            else if yourLike == "2"{
                postDetails?.dislikesCount = disLikesCount > 0 ? disLikesCount-1 : 0
            }
            else{
                postDetails?.likesCount = likesCount > 0 ? likesCount-1 : 0
                postDetails?.dislikesCount = disLikesCount + 1
            }
        }
        setUpLikeUnLikeViews(yourLike: postDetails?.yourLike)
    }
    // MARK: - ACTIONS
    @IBAction func sendBtnAction(_ sender:UIButton){
        if userVM.replyComment.value.isEmptyOrWhitespace(){
            showErrorMessages(message: "Please enter comment")
        }
        else{
            userVM.replyComment(postID: postDetails?.id ?? "")
        }
    }
}


extension BBoardPostDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVM.postComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCommentTableCell", for: indexPath) as! PostDetailCommentTableCell
        cell.configureCell(with: userVM.postComments[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


class PostDetailCommentTableCell: UITableViewCell {
    @IBOutlet weak var userNameLbl  : UILabel!
    @IBOutlet weak var userImg      : UIImageView!
    @IBOutlet weak var userComment  : UILabel!
    @IBOutlet weak var timeLbl      : UILabel!
    
    func configureCell(with data: PostDetails){
        userNameLbl.text = data.name ?? ""
        userImg.setImage(link: BaseURLs.userImgURL.rawValue + (data.profileImg ?? ""))
        userComment.text = data.comment ?? ""
        if let createDate = data.createdAt, let date = DateConvertor.shared.convert(dateInString: createDate, from: .yyyyMMddHHmmss, to: .yyyyMMddHHmmss).date, #available(iOS 13.0, *){
            timeLbl.text = date.timeAgoDisplay()
        }
        else{
            timeLbl.text = ""
        }
    }
}
