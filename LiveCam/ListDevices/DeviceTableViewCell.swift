//
//  DeviceTableViewCell.swift
//  LiveCam
//
//  Created by Developer 1 on 05/11/2024.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarCam: UIImageView!
    @IBOutlet weak var nameCam: UILabel!
    @IBOutlet weak var uidCam: UILabel!
    @IBOutlet weak var passCam: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: CameraModel) {
        nameCam.text = model.name
        uidCam.text = model.uid
        passCam.text = model.password
        
        if let avatarPath = model.avatar, let url = URL(string: "https://stagingapionehome.vnpt-technology.vn\(avatarPath)") {
            downloadImage(from: url)
        } else {
            avatarCam.image = UIImage(systemName: "web.camera")
        }
    }


    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let data = data, error == nil {
                    self.avatarCam.image = UIImage(data: data)
                } else {
                    self.avatarCam.image = UIImage(systemName: "web.camera")
                }
            }
        }.resume()
    }

    
}
