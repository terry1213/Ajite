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
    
    // ======================> 변수, outlet 선언
    
    var index: Int = 0
    var youtubeVideos = Playlist()
    
    @IBOutlet weak var youtubePlayer: YTPlayerView!
    // ==================================================================>
    
    // ======================> ViewController와 View 관련 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // ==================================================================>
    
    // ======================> 유튜브 영상 재생 관련 함수
    
    func loadFirstSong() {
        self.youtubePlayer.delegate = self;
        youtubePlayer.load(withVideoId: youtubeVideos.songs[index].videoID, playerVars: [
            "controls": 1,  //0: 영상 컨트롤 바 사라짐, 1: 컨트롤 바 생성
            "playsinline": 1,   //0: 전체 화면 재생, 1: playerView 화면 내애서 재생
        ])
        //view = youtubePlayer
    }
    
    //유튜브 플레이어 뷰가 준비 되면 실행될 함수
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        //영상을 자동으로 재생한다.
        youtubePlayer.playVideo()
    }
    
    //유트브 플레이어 상태가 변하면 실행될 함수
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        //유튜브 플레이어 상태가 '영상 종료'일 경우
        if state == YTPlayerState.ended {
            //인덱스 1 증가
            index += 1
            print("\(index)번째 비디오 종료")
            //뒤에 노래가 남았으면
            if index < youtubeVideos.songs.count{
                //해당 노래를 불러온다.
                self.youtubePlayer.load(withVideoId: youtubeVideos.songs[index].videoID, playerVars: [
                    "controls": 1,  //0: 영상 컨트롤 바 사라짐, 1: 컨트롤 바 생성
                    "playsinline": 1,   //0: 전체 화면 재생, 1: playerView 화면 내애서 재생
                ])
            }
        }
    }
    
    //특정 비디오를 재생하기 위해 사용하는 함수
    func playCertainVideo(_ indexOfSelectedSong: Int) {
        index = indexOfSelectedSong
        self.youtubePlayer.load(withVideoId: youtubeVideos.songs[indexOfSelectedSong].videoID, playerVars: [
            "controls": 1,  //0: 영상 컨트롤 바 사라짐, 1: 컨트롤 바 생성
            "playsinline": 1,   //0: 전체 화면 재생, 1: playerView 화면 내애서 재생
        ])
    }
    
    // ==================================================================>
    
}
