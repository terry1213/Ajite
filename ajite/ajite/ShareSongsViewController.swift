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

// ======================> Youtube data API를 통해 받은 정보를 저장하고 다루기 위한 struct

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

// ==================================================================>

class ShareSongsViewController: UIViewController {

    // ======================> 변수, outlet 선언
    
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
    
    @IBOutlet weak var youtubeVideoTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        print(ajiteID)
        super.viewDidLoad()
        self.youtubeVideoTableView.dataSource = self
        self.youtubeVideoTableView.delegate = self
        //getData(from: url)
        // Do any additional setup after loading the view.
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    @IBAction func pressShare(_ sender: Any) {
        listVC?.getData()
        dismiss(animated: true)
    }
    
    //검색 버튼 눌렀을 경우 검색어를 통해 유튜브 노래(영상) 데이터 불러오기
    @IBAction func searchAction(_ sender: Any) {
        //url을 통한 검색을 위해 space( )를 plus(+)로 전환
        getData(from: url + searchTextField.text!.replacingOccurrences(of: " ", with: "+"))
    }
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
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
    
    // ==================================================================>
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        //keyboard 아무 곳이나 터치하면 내려감
        self.view.endEditing(true)
        //유튜브 검색 테이블 뷰 밖을 터치하면
        let touch: UITouch? = touches.first!
        if touch?.view != youtubeVideoTableView {
            //유튜브 검색 테이블 뷰 없애기
            dismiss(animated: true)
        }
    }
    
    //keyboard return누르면 숨겨짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension ShareSongsViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
}

class YoutubeVideoSearchTableViewCell: UITableViewCell {
    
    // ======================> 변수, outlet 선언
    
    var playlistID: String!
    var ajiteID: String!
    var videoID: String!
    var thumbnailImageUrl: String!
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    // ==================================================================>
    
    // ======================> 초기화 함수
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    @IBAction func shareSong(_ sender: Any) {
        var ref: DocumentReference? = nil
        // 플레이리스트 ID 값이 있다면
        if playlistID != nil {
            //유저의, 현재 플레이리스트의, 노래 목록에 선택한 노래를 추가한다.
            self.addNewSongToPlaylist()
            //해당 플레이리스트 document에 노래 document를 추가한다.
            self.addSongNum()
        }
        // 아지트 ID 값이 있다면
        else if ajiteID != nil {
            //해당 아지트의 노래 목록에 선택한 노래를 추가한다.
            self.addNewSongToAjite()
        }
    }
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    //유저의, 현재 플레이리스트의, 노래 목록에 선택한 노래를 추가한다.
    func addNewSongToPlaylist() {
        var ref: DocumentReference? = nil
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
    
    //해당 플레이리스트 document에 노래 document를 추가한다.
    func addSongNum() {
        db
            .collection("users").document(myUser.documentID)
            .collection("playlists").document(playlistID).updateData([
                "songNum" : FieldValue.increment(Int64(1))
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
    }
    
    //해당 아지트의 노래 목록에 선택한 노래를 추가한다.
    func addNewSongToAjite() {
        var ref: DocumentReference? = nil
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
                "videoID": videoID as Any,
                //공유한 사람 등록
                "sharedPerson": myUser.documentID
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    // ==================================================================>
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
