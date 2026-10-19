//
//  ViewController.swift
//  DadJokes
//
//  Created by Dian Maisara on 12/10/26.
//

import UIKit

class ViewController: UIViewController {
    
    private let stackView = UIStackView()
    private var setupLabel = UILabel()
    private let whatButton = UIButton(type: .system)
    private var punchlineLabel = UILabel()
    private var continueLabel = UILabel()
    private var dadJokeImage = UIImageView()
    private var newJokeGesture: UITapGestureRecognizer!
    private var feedbackAlert = UIAlertController(title: "So...", message: "You like the joke or not?", preferredStyle: .alert)
    private var currentJokeIndex = 0
    private let delayInSeconds = 5.0
    
    let jokes = [
        Joke(setup: "What did the boy band that plays classical music name themselves?", punchline: "The Bach Street Boys..."),
        Joke(setup: "Why did the cow start taking singing lessons?", punchline: "To be a moo-sician!"),
        Joke(setup: "What do you call a musician with problems?", punchline: "A trebled individual."),
        Joke(setup: "What does a sword sound like?", punchline: "A little bit sharp")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupElements()
        setupLayout()
        setupGestures()
        
    }
    
    private func setupElements() {
        // Setup image
        dadJokeImage.image = UIImage(resource: .oldUncleIos)
        dadJokeImage.translatesAutoresizingMaskIntoConstraints = false
        dadJokeImage.contentMode = .scaleAspectFill
        dadJokeImage.isAccessibilityElement = true
        dadJokeImage.accessibilityLabel = "Old Singaporean Uncle Laughing"
        
        // Setup labels
        setupLabel.text = jokes[currentJokeIndex].setup //"Setup goes here"
        setupLabel.font = .systemFont(ofSize: 26)
        setupLabel.textColor = .black
        setupLabel.textAlignment = .center
        setupLabel.translatesAutoresizingMaskIntoConstraints = false
        setupLabel.numberOfLines = 0
        
        punchlineLabel.text = jokes[currentJokeIndex].punchline //"Punchline goes here"
        punchlineLabel.font = .systemFont(ofSize: 24)
        punchlineLabel.textColor = .red
        punchlineLabel.textAlignment = .center
        punchlineLabel.translatesAutoresizingMaskIntoConstraints = false
        punchlineLabel.numberOfLines = 0
        punchlineLabel.isHidden = true
        
        continueLabel.text = "Tap anywhere for more!"
        continueLabel.font = .systemFont(ofSize: 20)
        continueLabel.textColor = .black
        continueLabel.textAlignment = .center
        continueLabel.translatesAutoresizingMaskIntoConstraints = false
        continueLabel.isHidden = true
        
        // Setup button
        whatButton.setTitle("What?", for: .normal)
        whatButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        whatButton.backgroundColor = .systemBlue
        whatButton.setTitleColor(.white, for: .normal)
        whatButton.clipsToBounds = true
        whatButton.addTarget(self, action: #selector(whatButtonPressed), for: .touchUpInside)
        
        // Setup alert
        feedbackAlert.addAction(UIAlertAction(title: "Pa...", style: .cancel) { [weak self] _ in
            guard let self = self else { return }

            self.currentJokeIndex = (self.currentJokeIndex + 1) % self.jokes.count
            self.setupLabel.text = self.jokes[self.currentJokeIndex].setup
            self.punchlineLabel.text = self.jokes[self.currentJokeIndex].punchline
            
            refactoredToggles(punchlineStatus: true, buttonStatus: true, gestureStatus: false, continueStatus: true)
        })
        
        // Setup view
        view.addSubview(stackView)
        view.addSubview(continueLabel)
        
        // Setup stacking
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(dadJokeImage)
        stackView.addArrangedSubview(setupLabel)
        stackView.addArrangedSubview(whatButton)
        stackView.addArrangedSubview(punchlineLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            whatButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            whatButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            continueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupGestures() {
        newJokeGesture = UITapGestureRecognizer(target: self, action: #selector(tapAnywherePressed(_:)))
        newJokeGesture.isEnabled = false
        view.addGestureRecognizer(newJokeGesture)
        view.isUserInteractionEnabled = true
    }
    
    // reveal the punchline
    @objc private func whatButtonPressed() {
        
        refactoredToggles(punchlineStatus: false, buttonStatus: false, gestureStatus: true, continueStatus: false)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds {
//            [weak self] in self?.present(feedbackAlert, animated: true)
//        }
    }
    
    // move onto the next joke (cycle)
    @objc private func tapAnywherePressed(_ recognizer: UITapGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizer.State.ended) {
            present(feedbackAlert, animated: true)
        }
    }
    
    // helper to refactor the code and set the different UI Elements based on state
    private func refactoredToggles(punchlineStatus: Bool, buttonStatus: Bool, gestureStatus: Bool, continueStatus: Bool) {
        punchlineLabel.isHidden = punchlineStatus
        whatButton.isEnabled = buttonStatus
        newJokeGesture.isEnabled = gestureStatus
        continueLabel.isHidden = continueStatus
    }
}

#Preview {
    ViewController()
}
