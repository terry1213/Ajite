//
//  PlaylistViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//
/// Copyright (c) 2018 Razeware LLC used to animate
import UIKit
import Firebase
import FirebaseFirestore

class PlaylistViewController: UIViewController{

    //outlets and variables
    @IBOutlet weak var playlistTableView: UITableView!
    
    var shouldAnimateFirstRow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playlistTableView.dataSource = self
        self.playlistTableView.delegate = self
        //내비게이션 컨트롤러를 transparent 하게 바꿔준다
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
    }
    
   
    //getting data from database
    func getData(){
        db
            .collection("users").document(myUser.documentID)
            .collection("playlists").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //우선 전에 받아왔던 플레이리스트 정보들을 다 삭제한다.
                myUser.playlists.removeAll()
                //정보를 받아오기 위한 임시 플레이리스트 선언
                var temPlaylist: Playlist
                //firestore에서 본인의 플레이리스트를 전부 불러와서 하나하나씩 처리한다.
                for document in querySnapshot!.documents {
                    //다음 플레이리스트를 담기 위한 임시 플레이리스트 생성
                    temPlaylist = Playlist()
                    //플레이리스트 이름 받기
                    temPlaylist.playlistName = document.data()["name"] as! String
                    //플레이리스트 이미지 이름 받기
                    temPlaylist.playlistImageString = document.data()["playlistImageString"] as! String
                    //플레이리스트 아이디 받기
                    temPlaylist.songNum = document.data()["songNum"] as! Int
                    temPlaylist.id = document.documentID
                    //플레이리스트 목록에 추가
                    myUser.playlists.append(temPlaylist)
                }
                print("The number of playlists is \(myUser.playlists.count)")
                DispatchQueue.main.async{
                    //테이블에 불러온 정보를 보여준다.
                    self.playlistTableView.reloadData()
                }
            }
        }
    }
    
//************ 관련된 Action들 ********
    
    
    //adding to array of playlist classes
    @IBAction func plusTapped(_ sender: Any) {
        let alert = UIAlertController (title: "New Playlist", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (playlistTextField) in
            playlistTextField.placeholder = "Enter Playlist Name"
        })
        
        
        let action = UIAlertAction(title: "Add", style: .default){(_) in guard let newPlaylist = alert.textFields?.first?.text else{return}
            
            if newPlaylist.trimmingCharacters(in: .whitespaces).isEmpty{
                         let nameIsEmpty = UIAlertController(title: "Empty Name Field", message: "Your Playlist must have a name.", preferredStyle: .alert)
                         
                         nameIsEmpty.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                    NSLog("The \"OK\" alert occured.")}))
                                    
                                 self.present(nameIsEmpty, animated: true, completion: nil)
                                    return
                }
            //랜덤으로 플레이리스트 이미지를 정한다.
            let random = arc4random_uniform(4)
            let imageName = "\(random)"
            
            
            var ref: DocumentReference? = nil
            //본인의 플레이리스트 collection에 새로운 플레이리스트 추가
            ref = db
                .collection("users").document(myUser.documentID)
                .collection("playlists").addDocument(data: [
                    //입력한 이름을 등록
                    "name": newPlaylist,
                    //랜덤으로 선택된 이미지의 이름을 등록
                    "playlistImageString": imageName,
                    "songNum": 0
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Playlist added with ID: \(ref!.documentID)")
                    self.getData()
                }
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toPlaylist" else {
            return
        }
        guard let sendingPlaylist = sender as? Playlist else {
            return
        }
        guard let destination = segue.destination as? PlaylistSongListViewController else {
            return
        }
        //플레이리스트 내부 뷰에 플레이리스트 전송
        destination.source = sendingPlaylist
        //플레이리스트 내부 뷰에 플레이리스트 주인 정보 전달
        destination.currentUser = myUser
    }
    
}
extension PlaylistViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUser.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistTableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        //해당 플레이리스트 이름을 라벨에 적음
        cell.playlistName.text = myUser.playlists[indexPath.row].playlistName
        //해당 플레이리스트에 속한 노래의 개수를 적음
        cell.numberOfSongsInPlaylist.text = "\(myUser.playlists[indexPath.row].songNum) songs"
        //해당 플레이리스트의 이미지를 불러온다.
        cell.playlistImage.image = UIImage(named: "record-\( myUser.playlists[indexPath.row].playlistImageString)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 96
         }
    
    
    // 플레이리스트를 삭제할 때 사용하는 코드
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        let deleteAlert = UIAlertController (title: "Delete Playlist", message: "Would you like to delete your playlist?" ,preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action: UIAlertAction!) in
            
            guard editingStyle == .delete else { return }
            
            //현재 플레이리스트와 해당 플레이리스트에 속해있는 노래들을 삭제한다.
            db
                .collection("users").document(myUser.documentID)
                .collection("playlists").document(myUser.playlists[indexPath.row].id)
                .delete()
            
            myUser.playlists.remove(at: indexPath.row)
            self.playlistTableView.deleteRows(at: [indexPath], with: .automatic)
            
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = myUser.playlists[fromIndexPath.row]
            myUser.playlists.remove(at: fromIndexPath.row)
            myUser.playlists.insert(movedObject, at: to.row)
        }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
}

extension PlaylistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //전송할 플레이리스트 할당
        let dataToSend = myUser.playlists[indexPath.row]
        //플레이리스트 내부 뷰로 이동
        self.performSegue(withIdentifier: "toPlaylist", sender: dataToSend)
    }
}
