//
//  LoginOHViewController.swift
//  LiveCam
//
//  Created by Developer 1 on 01/11/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class LoginOHViewController: UIViewController {

    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfAccount: UITextField!
    let disposeBag = DisposeBag()
    var tokenLogin = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setupBindings()
    }
    
    func setupBindings() {
        let accountObservable = tfAccount.rx.text.orEmpty.asObservable()
        let passwordObservable = tfPassword.rx.text.orEmpty.asObservable()
        
        Observable.combineLatest(accountObservable, passwordObservable)
            .map { account, password in
                return !account.isEmpty && !password.isEmpty
            }
            .bind(to: buttonLogin.rx.isEnabled)
            .disposed(by: disposeBag)
        
        buttonLogin.rx.tap
            .withLatestFrom(Observable.combineLatest(accountObservable, passwordObservable))
            .flatMapLatest { [weak self] account, password -> Observable<[String: Any]> in
                guard let self = self else { return Observable.empty() }
                return self.login(account: account, password: password)
            }
            .observeOn(MainScheduler.instance) 
            .subscribe(onNext: { [weak self] json in
                if let idToken = json["id_token"] as? String {
                    print("Đăng nhập thành công với token: \(idToken)")
                    self?.tokenLogin = idToken
                    self?.navigateToListDevicesViewController()
                } else {
                    self?.showLoginError("Token không hợp lệ.")
                }
            }, onError: { [weak self] error in
                self?.showLoginError("Đăng nhập thất bại: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func login(account: String, password: String) -> Observable<[String: Any]> {
        return Observable.create { observer in
            let url = "https://stagingapionehome.vnpt-technology.vn/api/auth/token"
            
            let parameters: [String: Any] = [
                "username": account,
                "password": password,
                "type": 1
            ]
            
            let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            
            request.responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let jsonResponse = value as? [String: Any] {
                        print("Phản hồi từ server:", jsonResponse) // In toàn bộ JSON để xem nội dung
                        observer.onNext(jsonResponse)
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"]))
                    }
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }

    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func navigateToLoginViewController() {
        let loginCam = LoginViewController()
        navigationController?.pushViewController(loginCam, animated: true)
    }
    func navigateToListDevicesViewController() {
        let listDevices = ListDevicesViewController()
        listDevices.token = tokenLogin
        navigationController?.pushViewController(listDevices, animated: true)
    }
    
    func showLoginError(_ message: String) {
        let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
        print(alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
