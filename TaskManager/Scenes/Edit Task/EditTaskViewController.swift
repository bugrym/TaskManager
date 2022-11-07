//
//  EditTaskViewController.swift
//  TaskManager
//
//  Created by vbugrym on 06.11.2022.
//

import UIKit

final class EditTaskViewController: UIViewController, Storyboardable {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var textView: UITextView! {
        didSet {
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
    var viewModel: EditTaskViewModel!
    private lazy var rightItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Save",
                               style: .done,
                               target: nil,
                               action: #selector(saveChanges))
    }()
    
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
        textView.text = viewModel.description
        
        viewModel.onValidateBtn = { [weak self] in
            guard let strongsSelf = self else { return }
            strongsSelf.configureSaveBtn()
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = viewModel.title
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func configureSaveBtn() {
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.isSaveEnabled
    }
    
    // MARK: - Objc methods
    @objc
    private func saveChanges() {
        isLoading(true)
        viewModel.saveChanges { [weak self] in
            guard let strongsSelf = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                strongsSelf.isLoading(false)
                strongsSelf.viewModel.onSuccessSave?()
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

extension EditTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        viewModel.updateDescription(text)
    }
}
