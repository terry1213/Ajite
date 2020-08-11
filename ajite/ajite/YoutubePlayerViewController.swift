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
    var index: Int = 0
    var youtubeVideos = Playlist()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }

    override func loadView() {
        youtubePlayer = YTPlayerView()
        self.youtubePlayer.delegate = self;
        self.youtubePlayer.load(withVideoId: youtubeVideos.songs[index].videoID, playerVars: [
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
            index += 1
            print("\(index)번째 비디오 종료")
            if index < youtubeVideos.songs.count{
                self.youtubePlayer.load(withVideoId: youtubeVideos.songs[index].videoID, playerVars: [
                    "controls": 1,  //0: 영상 컨트롤 바 사라짐, 1: 컨트롤 바 생성
                    "playsinline": 1,   //0: 전체 화면 재생, 1: playerView 화면 내애서 재생
                ])
            }
        }
    }
    
    func playCertainVideo() {
        self.youtubePlayer.load(withVideoId: youtubeVideos.songs[index].videoID, playerVars: [
            "controls": 1,  //0: 영상 컨트롤 바 사라짐, 1: 컨트롤 바 생성
            "playsinline": 1,   //0: 전체 화면 재생, 1: playerView 화면 내애서 재생
        ])
    }
}
