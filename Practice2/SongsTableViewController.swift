//
//  SongsTableViewController.swift
//  Practice2
//
//  Created by Ned Ruggeri on 3/25/17.
//  Copyright © 2017 Ned Ruggeri. All rights reserved.
//

import UIKit

class SongsTableViewController : UITableViewController {
    var allFiles: Array<String> = []
    var songSelectionCallback: ((String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.allFiles = try! FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SONG_CELL")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allFiles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songCell = self.tableView.dequeueReusableCell(withIdentifier: "SONG_CELL")!
        songCell.textLabel!.text = allFiles[indexPath.row]
        return songCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.songSelectionCallback!(Bundle.main.bundlePath + "/" + allFiles[indexPath.row])
        self.dismiss(animated: true)
    }
}
