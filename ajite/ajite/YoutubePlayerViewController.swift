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
    var isLoop: Int = 0
    var isShuffle: Bool = false
    var youtubeVideos = Playlist()
    
    @IBOutlet weak var youtubePlayer: YTPlayerView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    // ==================================================================>
    
    // ======================> ViewController와 View 관련 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // ==================================================================>
    
    // ======================> 유튜브 영상 재생 관련 함수
    
    func loadFirstSong() {
        self.youtubePlayer.delegate = self;
        if(youtubeVideos.songs.count != 0){
            playCertainVideo(index)
        }
        youtubePlayer.layer.cornerRadius = 10
        youtubePlayer.layer.masksToBounds = true
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
            print("\(index + 1)번째 비디오 종료")
            if isLoop == 2 {
                playCertainVideo(index)
            }
            //뒤에 노래가 남았으면
            else if index < youtubeVideos.songs.count-1{
                //인덱스 1 증가
                index += 1
                //해당 노래를 불러온다.
                playCertainVideo(index)
            }
            else if isLoop == 1 {
                index = 0
                playCertainVideo(index)
            }
        }
    }
    
    //특정 비디오를 재생하기 위해 사용하는 함수
    func playCertainVideo(_ indexOfSelectedSong: Int) {
        index = indexOfSelectedSong
        songName.text = youtubeVideos.songs[index].name
        artist.text = youtubeVideos.songs[index].artist
        
        self.youtubePlayer.load(withVideoId: youtubeVideos.songs[index].videoID, playerVars: [
            "controls": 1,  //0: 영상 컨트롤 바 사라짐, 1: 컨트롤 바 생성
            "playsinline": 1,   //0: 전체 화면 재생, 1: playerView 화면 내애서 재생
        ])
    }
    
    // ==================================================================>
    
    @IBAction func PreviousSongButtonTouched(_ sender: Any) {
        if index != 0 {
            index -= 1
        }
        playCertainVideo(index)
    }
    
    @IBAction func nextSongButtonTouched(_ sender: Any) {
        if index < youtubeVideos.songs.count-1{
            //인덱스 1 증가
            index += 1
            //해당 노래를 불러온다.
            playCertainVideo(index)
        }
        else if isLoop == 1 {
            index = 0
            playCertainVideo(index)
        }
    }
    
    @IBAction func loopButtonTouched(_ sender: Any) {
        isLoop = (isLoop + 1) % 3
        switch isLoop {
        case 0:
            loopButton.setImage(UIImage(systemName: "repeat"), for: .normal)
            loopButton.tintColor = .lightGray
            break
        case 1:
            loopButton.tintColor = .systemBlue
            break
        case 2:
            loopButton.setImage(UIImage(systemName: "repeat.1"), for: .normal)
            break
        default:
            break
        }
    }
    
    @IBAction func shuffleButtonTouched(_ sender: Any) {
        isShuffle = !isShuffle
        switch isShuffle {
        case true:
            shuffleButton.tintColor = .systemBlue
            if let parent = self.parent as? PlaylistViewController {
                let currentSong = parent.playlist.songs.remove(at: index)
                parent.playlist.songs.shuffle()
                parent.playlist.songs.insert(currentSong, at: 0)
                parent.songTable.reloadData()
                youtubeVideos = parent.playlist
                index = 0
            }
            break
        case false:
            shuffleButton.tintColor = .lightGray
            break
        }
    }
}
