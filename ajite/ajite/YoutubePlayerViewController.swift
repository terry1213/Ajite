//
//  YoutubePlayerViewController.swift
//  ajite
//
//  Created by 임연우 on 2020/08/01.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import GoogleAPIClientForREST

struct Response: Codable {
    let status: String
}

class YoutubePlayerViewController: UIViewController, YTPlayerViewDelegate{
    
    var youtubePlayer: YTPlayerView!
    let videoId: [String] = ["xhyglLj3pQI", "l5i8YoFBvO4"]
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=viewCount&q=헤이즈&videoDefinition=high&type=video&regionCode=KR&key=AIzaSyC5dPLHRMBA3TnwI6AHu6ypUeOTF-AEGeg"
        getData(from: url)
    }

    override func loadView() {
        youtubePlayer = YTPlayerView()
        self.youtubePlayer.delegate = self;
        self.youtubePlayer.load(withVideoId: videoId[index], playerVars: [
            "controls": 1,  //0: 영상 컨트롤 바 사라짐, 1: 컨트롤 바 생성
            "playsinline": 1,   //0: 전체 화면 재생, 1: playerView 화면 내애서 재생
        ])
        view = youtubePlayer
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        youtubePlayer.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == YTPlayerState.ended {
            print("finished")
            index += 1
            if index < videoId.count{
                self.youtubePlayer.load(withVideoId: videoId[index], playerVars: [
                    "controls": 1,  //0: 영상 컨트롤 바 사라짐, 1: 컨트롤 바 생성
                    "playsinline": 1,   //0: 전체 화면 재생, 1: playerView 화면 내애서 재생
                ])
            }
        }
    }
    
    func getData(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                        print(JSONString)
                    }
                    //print("Response from YouTube: \(jsonResult)")
                }
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
        })
        
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
