//
//  ShareSongsViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import Firebase
import FirebaseFirestore

//유튜브 데이터 모델
struct YouTubeModel: Codable {
//    let kind, etag: String?
//    let pageInfo: PageInfo?
    let items: [Item]
}

//아이템 정보(비디오)
struct Item: Codable {
//    let kind, etag: String?
    let id: Id?
    let snippet: Snippet?
}

//아이템의 아이디
struct Id: Codable {
//    let kind: String?
    let videoId: String?
}

struct Snippet: Codable {
    let title: String?
//    let snippetDescription: String?
//    let publishedAt: String?
    let channelTitle: String?
//    let publishTime: String?
    let thumbnails: Thumbnails?
//    let country: String?

    enum CodingKeys: String, CodingKey {
        case title, channelTitle, thumbnails
//        case snippetDescription = "description"
//        case publishedAt, country, publishTime
    }
}

//썸네일 정보(화질, url)
struct Thumbnails: Codable {
    let thumbnailsDefault: Default
//    let medium, high: Default

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
//        case medium, high
    }
}

struct Default: Codable {
    let url: String
//    let width, height: Int
}

//페이지 정보
//struct PageInfo: Codable {
//    let totalResults, resultsPerPage: Int?
//}

class ShareSongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var youtubeVideoTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var listVC: PlaylistSongListViewController? = nil
    //검색된 결과(유튜브 데이터 모델)
    var youTubeModel: YouTubeModel?
    //기본 url, 마지막 'q=' 이후에 검색어 붙여서 사용
    let url: String = "https://www.googleapis.com/youtube/v3/search?part=snippet&fields=items(id(videoId),snippet(channelTitle,title,thumbnails(default(url))))&order=viewCount&videoDefinition=high&type=video&regionCode=KR&key=AIzaSyC5dPLHRMBA3TnwI6AHu6ypUeOTF-AEGeg&q="
    /*
     keys
        AIzaSyC5dPLHRMBA3TnwI6AHu6ypUeOTF-AEGeg
        AIzaSyA56mjgLpsdf1Sz6AqKuNSTIIuyQHpED2c
     */
    var playlistID: String!
    var ajiteID: String!
    
    //keyboard return누르면 숨겨짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        print(ajiteID)
        super.viewDidLoad()
        self.youtubeVideoTableView.dataSource = self
        self.youtubeVideoTableView.delegate = self
        //getData(from: url)
        // Do any additional setup after loading the view.
    }
    //keyboard 아무 곳이나 터치하면 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    
    @IBAction func pressShare(_ sender: Any) {
        listVC?.getData()
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youTubeModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeVideoSearchTableViewCell", for: indexPath) as! YoutubeVideoSearchTableViewCell
        //노래(영상) 이름 불러오기
        cell.songNameLabel.text = youTubeModel?.items[indexPath.row].snippet?.title
        //아티스트(업로드한 채널) 이름 불러오기
        cell.artistLabel.text = youTubeModel?.items[indexPath.row].snippet?.channelTitle
        //썸네일 사진 불러오기
        let data = try? Data(contentsOf: URL(string: (youTubeModel?.items[indexPath.row].snippet?.thumbnails?.thumbnailsDefault.url)!)!)
        DispatchQueue.main.async {
            cell.thumbnailImageView.image = UIImage(data: data!)
        }
        //비디오 아이디 불러오기
        cell.videoID = youTubeModel?.items[indexPath.row].id?.videoId
        //playlistID,ajiteID 세팅
        cell.playlistID = self.playlistID
        cell.ajiteID = self.ajiteID
        cell.thumbnailImageUrl = youTubeModel?.items[indexPath.row].snippet?.thumbnails?.thumbnailsDefault.url
        return cell
    }
    
    func getData(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            do {
                self.youTubeModel = try JSONDecoder().decode(YouTubeModel.self, from: data)
                //데이터 리로드(갱신), 새로 가져온 정보를 데이블 뷰에 적용
                DispatchQueue.main.async{
                    self.youtubeVideoTableView.reloadData()
                }
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
        })
        task.resume()
        
    }
    
    //검색 버튼 눌렀을 경우 검색어를 통해 유튜브 노래(영상) 데이터 불러오기
    @IBAction func searchAction(_ sender: Any) {
        //url을 통한 검색을 위해 space( )를 plus(+)로 전환
        getData(from: url + searchTextField.text!.replacingOccurrences(of: " ", with: "+"))
    }
    
    /*
    // MARK: - Navigation

     @IBAction func pressedShare(_ sender: Any) {
     }
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class YoutubeVideoSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var playlistID: String!
    var ajiteID: String!
    var videoID: String!
    var thumbnailImageUrl: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func shareSong(_ sender: Any) {
        var ref: DocumentReference? = nil
        if playlistID != nil {
            
            //유저의, 현재 플레이리스트의, 노래 목록에 선택한 노래를 추가한다.
            ref = db
                .collection("users")
                .document(myUser.documentID)
                .collection("playlists")
                .document(playlistID)
                .collection("songs")
                .addDocument(data: [
                    //노래 이름 등록
                    "name": songNameLabel.text as Any,
                    //아티스트(채널) 이름 등록
                    "artist": artistLabel.text as Any,
                    //썸네일 이미지 url 등록
                    "thumbnailImageUrl": thumbnailImageUrl as Any,
                    //비디오 ID 등록
                    "videoID": videoID as Any
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        else if ajiteID != nil {
            //해당 아지트의 노래 목록에 선택한 노래를 추가한다.
            ref = db
                .collection("ajites")
                .document(ajiteID)
                .collection("sharedSongs")
                .addDocument(data: [
                    //노래 이름 등록
                    "name": songNameLabel.text as Any,
                    //아티스트(채널) 이름 등록
                    "artist": artistLabel.text as Any,
                    //썸네일 이미지 url 등록
                    "thumbnailImageUrl": thumbnailImageUrl as Any,
                    //비디오 ID 등록
                    "videoID": videoID as Any
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    
}
