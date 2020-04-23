//
//  MainViewController.swift
//  BCD
//
//  Created by Liuliet.Lee on 17/6/2017.
//  Copyright © 2017 Liuliet.Lee. All rights reserved.
//

import UIKit
import SWRevealViewController
import ViewAnimator
import LLDialog

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var menu: UIBarButtonItem!
    private var manager = HistoryManager()
    var cover = BilibiliCover(bvid: "")
    
    var currentCoverType: CoverType {
        get { cover.type }
        set {
            if newValue == .bvideo {
                searchField.keyboardType = .asciiCapable
                searchField.autocorrectionType = .no
                typeLabel.text = "视频 BV"
                cover = BilibiliCover(bvid: "")
            } else {
                searchField.keyboardType = .numberPad
                cover = BilibiliCover(id: 0, type: newValue)
                switch newValue {
                case .video:    typeLabel.text = "视频 AV"
                case .article:  typeLabel.text = "专栏 CV"
                case .live:     typeLabel.text = "直播间 LV"
                default: break
                }
            }
            searchField.text = ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
        view.endEditing(true)
        NotificationCenter.default.addObserver(
            self, selector: #selector(getURLFromPasteboard),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        #if targetEnvironment(macCatalyst)
        NotificationCenter.default.addObserver(
            self, selector: #selector(getURLFromPasteboard),
            name: Notification.Name(rawValue: "NSWindowDidBecomeKeyNotification"),
            object: nil
        )
        #endif
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getURLFromPasteboard()
    }

    @objc private func getURLFromPasteboard() {
        BilibiliCover.fromPasteboard { [weak self] (newCover) in
            guard self != nil,
                let newCover = newCover,
                self!.cover != newCover
                else { return }
            DispatchQueue.main.async {
                guard let self = self, !isShowingImage else { return }
                self.currentCoverType = newCover.type
                self.cover = newCover
                self.searchField.text = String(newCover.shortDescription.dropFirst(2))
                self.goButton.isEnabled = true
                guard self.manager.itemInHistory(cover: newCover) == nil else { return }
                isShowingImage = true
                self.performSegue(withIdentifier: "showImageVC", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isShowingImage = false
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(searchFieldDidChanged), for: .editingChanged)
        searchField.layer.borderColor = UIColor.clear.cgColor
        goButton.isEnabled = false
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        promptToShowAppTutorialIfNeeded()
        promptToShowAutoHidTutorialIfNeeded()
    }
        
    @IBAction func switchCoverType() {
        let currentType = cover.type.rawValue
        let nextType = currentType % 4 + 1
        currentCoverType = CoverType(rawValue: nextType)!
        goButton.isEnabled = false
        view.endEditing(true)
    }
    
    private func promptToShowAutoHidTutorialIfNeeded() {
        guard needToDisplayAutoHideTutorial else { return }
        LLDialog()
            .set(title: "(=・ω・=)")
            .set(message: "想了解下「自动和谐」的什么东西嘛？")
            .setNegativeButton(withTitle: "不想")
            .setPositiveButton(withTitle: "好的", target: self, action: #selector(showAutoHidTutorial))
            .show()
    }
    
    private func promptToShowAppTutorialIfNeeded() {
        guard needToDisplayAppTutorial else { return }
        LLDialog()
            .set(title: "(=・ω・=)")
            .set(message: "想看看这个 App 的使用说明嘛？")
            .setNegativeButton(withTitle: "不想")
            .setPositiveButton(withTitle: "好的", target: self, action: #selector(showAppTutorial))
            .show()
    }
    
    @objc private func showAutoHidTutorial() {
        let vc = HisTutViewController()
        vc.page = "AutoHide"
        present(vc, animated: true)
    }
    
    @objc private func showAppTutorial() {
        let tutorialViewController = storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
        present(tutorialViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ImageViewController {
            vc.cover = cover
            view.endEditing(true)
            if let eCover = manager.itemInHistory(cover: cover) {
                vc.itemFromHistory = eCover
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func searchFieldDidChanged() {
        if currentCoverType == .bvideo {
            cover.bvid = searchField.text!
        } else {
            cover.number = UInt64(searchField.text!) ?? 0
        }
        goButton.isEnabled = searchField.text != ""
    }
}
