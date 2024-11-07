//
//  ListDevicesViewController.swift
//  LiveCam
//
//  Created by Developer 1 on 05/11/2024.
//

import UIKit
import Alamofire

class ListDevicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableListDevices: UITableView!
    
    var token: String?
    var devices: [CameraModel] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableListDevices.dataSource = self
        tableListDevices.delegate = self
        tableListDevices.register(UINib(nibName: "DeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "deviceCell")
        
        fetchDevices()
    }
        
    private func fetchDevices() {
        guard let token = token else {
            print("Token is nil")
            return
        }
        print("List Devices: \(token)")
        
        let url = "https://stagingapionehome.vnpt-technology.vn/api/devices/search?query=&page=0&size=100"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: [CameraModel].self) { [weak self] response in
            switch response.result {
            case .success(let devices):
                print("Decoded devices:", devices)
                DispatchQueue.main.async {
                    self?.devices = devices
                    self?.tableListDevices.reloadData()
                }
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    print("HTTP Error:", statusCode)
                }
                print("Failed to fetch devices or decode JSON:", error)
            }
        }
    }
        
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return devices.count
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as? DeviceTableViewCell else {
                return UITableViewCell()
            }
            
            let device = devices[indexPath.row]
            cell.configure(with: device)
            
            return cell
    }
}
