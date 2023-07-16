//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/4/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    internal var weatherViewModel: WeatherViewModel
    
    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // stack views
    let rootStackView = UIStackView()
    let topStackView = TopStackView()
    let bottomStackView = BottomStackView()

    // background view
    let backgroundView = UIImageView()
            
    // bottom stack view content
    let bottomStackContainer = UIView()
    
    let locationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupUI()
        setupLayout()
        updateWeatherData()
        setupTapGesture()
        displayErrorClosure()
    }
    
    internal func setupUI() {
        bottomStackView.cityTextField.delegate = self

        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named: "background")
        backgroundView.contentMode = .scaleAspectFill
        
        bottomStackContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomStackContainer.layer.borderWidth = 5.0
        bottomStackContainer.layer.borderColor = UIColor.white.cgColor
        bottomStackContainer.layer.cornerRadius = 8.0
        bottomStackContainer.clipsToBounds = true
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(backgroundView)
        view.addSubview(rootStackView)
        view.addSubview(locationButton)
        
        rootStackView.addSubview(topStackView)
        rootStackView.addSubview(bottomStackContainer)
        bottomStackContainer.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 2),
            rootStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            topStackView.topAnchor.constraint(equalToSystemSpacingBelow: rootStackView.topAnchor, multiplier: 10),
            topStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.leadingAnchor, multiplier: 2),
            rootStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: topStackView.trailingAnchor, multiplier: 2),
            
            bottomStackContainer.centerXAnchor.constraint(equalTo: rootStackView.centerXAnchor),
            bottomStackContainer.centerYAnchor.constraint(equalTo: rootStackView.centerYAnchor),
            bottomStackContainer.leadingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.leadingAnchor, multiplier: 2),
            rootStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: bottomStackContainer.trailingAnchor, multiplier: 2),
            
            bottomStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: bottomStackContainer.leadingAnchor, multiplier: 2),
            bottomStackContainer.trailingAnchor.constraint(equalToSystemSpacingAfter: bottomStackView.trailingAnchor, multiplier: 2),
            bottomStackView.topAnchor.constraint(equalToSystemSpacingBelow: bottomStackContainer.topAnchor, multiplier: 5),
            bottomStackContainer.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomStackView.bottomAnchor, multiplier: 5),
            
            locationButton.topAnchor.constraint(equalToSystemSpacingBelow: rootStackView.topAnchor, multiplier: 1),
            rootStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: locationButton.trailingAnchor, multiplier: 2),
            
            locationButton.widthAnchor.constraint(equalToConstant: 35),
            locationButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    internal func updateWeatherData() {
        weatherViewModel.fetchWeatherForCurrentLocation()
        weatherViewModel.didUpdateWeatherData = { [weak self] in
            self?.updateUI()
        }
    }
    
    @objc internal func locationButtonClicked() {
        updateWeatherData()
    }
    
    internal func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            bottomStackView.cityTextField.text = weatherViewModel.cityTextFieldString
            bottomStackView.dateLabel.text = weatherViewModel.todayDateString
            bottomStackView.minTempLabel.text = weatherViewModel.minTempString
            bottomStackView.maxTempLabel.text = weatherViewModel.maxTempString
            bottomStackView.humidityLabel.text = weatherViewModel.humidityString
            
            topStackView.temperatureLabel.text = weatherViewModel.temperatureString
            topStackView.weatherDescriptionLabel.text = weatherViewModel.weatherDescriptionString
            topStackView.weatherImageView.image = UIImage(systemName: weatherViewModel.weatherImageIconName)
            topStackView.weatherImageView.tintColor = weatherViewModel.weatherImageIconColor
        }
    }
    
    // Hide the keyboard and fetch weather data when user taps the view
    @objc internal func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let tapLocation = sender.location(in: view)
            if !bottomStackView.cityTextField.frame.contains(tapLocation) {
                view.endEditing(true)
                Task {
                    await weatherViewModel.fetchWeatherData(city: bottomStackView.cityTextField.text ?? "")
                }
            }
        }
    }
    
    private func displayErrorClosure() {
        weatherViewModel.didDisplayError = { [weak self] title, message in
            DispatchQueue.main.async {
                guard let viewController = self else {
                    return
                }
                Helpers.showAlert(title: title, message: message, over: viewController)
                self?.self.bottomStackView.cityTextField.text = ""
            }
        }
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == bottomStackView.cityTextField {
            Task {
                await weatherViewModel.fetchWeatherData(city: textField.text ?? "")
            }
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}
