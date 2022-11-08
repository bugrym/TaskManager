//
//  AddTaskViewController.swift
//  TaskManager
//
//  Created by vbugrym on 26.06.2022.
//

import UIKit

final class AddTaskViewController: UIViewController, Storyboardable {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var saveBtn: UIButton!
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.keyboardDismissMode = .onDrag
            textView.autocorrectionType = .no
            textView.layer.cornerRadius = 8
            textView.layer.borderColor = UIColor.systemBlue.cgColor
            textView.layer.borderWidth = 2 
        }
    }
    @IBOutlet private weak var loader: UIActivityIndicatorView! {
        didSet {
            loader.isHidden = true
        }
    }
    
    // MARK: - Properties
    var viewModel: AddTaskViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        bind()
        setupNavigation()
        configureSaveBtn()
    }
    
    // MARK: - Methods
    private func bind() {
        viewModel.onValidateBtn = { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.configureSaveBtn()
            }
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = viewModel.title
    }
    
    private func configureSaveBtn() {
        saveBtn.isEnabled = viewModel.isSaveEnabled
    }
    
    @IBAction func saveBtnTap() {
        isLoading(true)
        viewModel.saveTask() { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                strongSelf.textView.text.removeAll()
                strongSelf.isLoading(false)
            }
        }
    }
    
    // MARK: - Support methods
    private func isLoading(_ loading: Bool) {
        if loading {
            loader.isHidden = false
            loader.startAnimating()
        } else {
            loader.isHidden = true
            loader.stopAnimating()
        }
    }
}

extension AddTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        viewModel.updateDescription(text)
    }
}
