//
//  WingWomenDetailVC.swift
//  BList
//
//  Created by PARAS on 30/05/22.
//

import UIKit

class WingWomenDetailVC: BaseClassVC {
    @IBOutlet weak var tbl_list : UITableView!
    var data = [("Summary",("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Read More","summary_ex")),("Experiences To Share",("hiking, clubbing, dancing, and etc Read More","experiences_ex")),("In Exchange For",("This is a number value from “Free to whatever price they set and it is also text box, member can explain Read More","user_ex")),("My Best Quality",("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean at porttitor nibh. Phasellus mauris risus, Read More","tick_ex")),("About Me",("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean at porttitor nibh. Phasellus mauris risus, maximus eu massa et, volutpat rhoncus justo Read More","info_ex"))]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
extension WingWomenDetailVC:UITableViewDataSource,UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Wing_WomenDetailCell") as? Wing_WomenDetailCell else{
            return Wing_WomenDetailCell()
        }
        cell.lbl_Description.text = data[indexPath.row].1.0
        cell.lbl_title.text = data[indexPath.row].0
        cell.img_women.image = UIImage.init(named: data[indexPath.row].1.1)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if data[indexPath.row].1.0 == "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Read More"{
            data[indexPath.row].1.0 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam tellus dolor, ultricies sed neque nec, condimentum pharetra magna. Integer viverra risus vitae est tempor facilisis. Nunc nec dictum augue, vitae dignissim tortor. Donec lobortis massa at dignissim pretium. Aenean ac orci laoreet lorem tristique feugiat. Proin est lorem, sollicitudin ultrices aliquet at, interdum vel nisi. Etiam pharetra suscipit nunc, sit amet consectetur lectus imperdiet a. Nulla et pellentesque dui. Sed vitae mauris justo. Suspendisse auctor felis orci, a egestas risus porttitor sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. In volutpat sapien arcu, vel maximus enim dapibus dapibus. Mauris efficitur tempor ipsum vel auctor. Cras urna justo, placerat a gravida quis, tincidunt id arcu. Donec congue sit amet lorem quis mattis. Cras vel ipsum faucibus, luctus nibh in, tempor libero. Quisque sapien erat, laoreet eget pellentesque in, placerat et est. Maecenas sodales viverra velit, id laoreet enim pulvinar in. Sed odio ipsum, bibendum ut neque eu, bibendum dapibus nunc. In commodo aliquam velit, id sodales tortor cget lorem. Praesent tempus metus vel nulla malesuada, vel malesuada orci tempus. Read More"
            }
            else{
                data[indexPath.row].1.0 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Read More"
            }
            tbl_list.reloadRows(at: [indexPath], with: .automatic)

        }
    }
}
class Wing_WomenDetailCell : UITableViewCell{
    @IBOutlet weak var lbl_Description : UILabel!
    @IBOutlet weak var lbl_title : UILabel!
    @IBOutlet weak var img_women : UIImageView!
}
