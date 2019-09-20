//
//  HiraganaViewController.swift
//  Hiragana
//
//  Created by Mohan on 2019/09/20.
//  Copyright © 2019 mmk. All rights reserved.
//

import UIKit
import Alamofire

class HiraganaViewController: UIViewController {

    @IBOutlet weak var txt_input: UITextField!
    @IBOutlet weak var btn_translate: UIButton!
    @IBOutlet weak var txt_output: UITextField!
    @IBOutlet weak var btn_clear: UIButton!
    
    // gooラボに登録した時もらったキー
    let APIKey = "60403d8a343a5758afed838e055a9d6dbb4706fb2551ff1a2b63431223901fc0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txt_output.isEnabled = false
    }
    
    func CallAPIUsingAlamofire() {
        guard let serverURL = URL(string: "https://labs.goo.ne.jp/api/hiragana") else {
            return
        }
        
        // アップするJsonを作成
        let params = [
            "app_id" : APIKey,
            "request_id": "record001",
            "sentence": txt_input.text as Any,
            "output_type": "hiragana"
            ] as [String : Any]
        
        // API Call
        Alamofire.request(serverURL, method: .post, parameters: params as Parameters, encoding: JSONEncoding.default).validate()
            .responseJSON { response in
            switch response.result {
            case .success:
                print("# SUCCESS")
                let myJsonData = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary
                
                let convertedVal = myJsonData?.value(forKey: "converted")
                
                self.txt_output.text = (convertedVal as! String)
                
            case .failure:
                print("# ERROR")
                print(Error.self)
            }
        }
    }
    
    @IBAction func btn_translateTouch(_ sender: Any) {
        let textVal = txt_input.text
        
        // Textbox空の場合メッセージ表示
        if textVal!.isEmpty {
            let alert = UIAlertController(title: "Empty Text", message: "文書を入力してください。", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
        else {
            CallAPIUsingAlamofire()
        }
    }
    
    @IBAction func btn_clearTouch(_ sender: Any) {
        txt_input.text?.removeAll()
        txt_output.text?.removeAll()
    }
}
