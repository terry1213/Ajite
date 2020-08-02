//
//  YoutubePlayerViewController.swift
//  ajite
//
//  Created by 임연우 on 2020/08/01.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YoutubePlayerViewController: UIViewController, YTPlayerViewDelegate{
    
    var youtubePlayer: YTPlayerView!
    let videoId: [String] = ["xhyglLj3pQI", "l5i8YoFBvO4"]
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
