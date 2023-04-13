//
//  EDFileContentController.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/12.
//  Copyright © 2023 zluof <https://github.com/zlfyuan/>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE
//

class EDFileContentController: EDBaseController {
    
    var textView: UITextView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let textFrame = CGRect.init(x: 16,
                                    y: self.navigationController!.navigationBar.frame.maxY + 10 ,
                                    width: self.view.frame.width - 32,
                                    height: self.view.frame.height - self.navigationController!.navigationBar.frame.maxY + 10 - self.tabBarController!.tabBar.frame.height)

        textView.frame = textFrame
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textColor = .systemGray
        self.view.addSubview(textView)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: String.edLocalizedString(withKey: "title.share"), style: .plain, target: self, action: #selector(shareBarButtonItemAction))]
    }
    
    @objc func shareBarButtonItemAction() {
        if let text = self.fileModel?.pathUrl {
            EDCommon.share(text, in: self)
        }
    }
    
    var fileModel: FileDataModel? = nil {
        didSet{
            guard let _model = fileModel,
             let _content = SandBoxManger.readFile(model: _model) as? String  else { return }
            textView.text = "\(_content)"
        }
    }
}
