//
//  TextedCatViewController.swift
//  ConcerteApp
//
//  Created by Савелий Коцур on 03.11.2024.
//

import UIKit

class TextedCatViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        label.text = "Напиши текст и отправь запрос!"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func downloadCat(_ text: String) {
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.catImage.image = UIImage(data: data)
                self?.label.text = "Загрузка кота закончена"
                self?.activityIndicator.stopAnimating()
                self?.button.isEnabled = true
                self?.textField.isEnabled = true
            }
        }
        
        task.resume()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @IBAction func didTappedButton(_ sender: Any) {
        if textField.text != "" {
            activityIndicator.startAnimating()
            button.isEnabled = false
            textField.isEnabled = false
            label.text = "Скачиваю кота..."
            downloadCat(textField.text!)
        } else {
            label.text = "Введите запрос!"
        }
    }
}

