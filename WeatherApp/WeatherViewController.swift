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
    let topStackView = UIStackView()
    let topWeatherStackView = UIStackView()
    let bottomStackView = UIStackView()
    let bottomWeatherTempInfoStackView = UIStackView()
    
    // background
    let backgroundView = UIImageView()
    
    // top stack view content
    let temperatureLabel = UILabel()
    let weatherDescriptionLabel = UILabel()
    let weatherImageView = UIImageView()
    
    // bottom stack view content
    let bottomStackContainer = UIView()
    let cityTextField = UITextField()
    let locationButton = UIButton()
    let dateLabel = UILabel()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    let humidityLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupUI()
        setupLayout()
        updateWeatherData()
        setupTapGesture()
        displayErrorClosure()
    }
    
    internal func setupUI() {
        cityTextField.delegate = self

        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named: "background")
        backgroundView.contentMode = .scaleAspectFill
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .horizontal
        topStackView.spacing = 10
        topStackView.alignment = .top
        
        topWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
        // topWeatherStackView.alignment = .leading
        topWeatherStackView.axis = .vertical
        topWeatherStackView.spacing = 10
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 60)
        temperatureLabel.tintColor = .label
        
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.image = UIImage(systemName: "sun.max")
        weatherImageView.tintColor = .label
        weatherImageView.contentMode = .scaleAspectFill
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .center
        bottomStackView.spacing = 15
        
        bottomStackContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomStackContainer.layer.borderWidth = 5.0
        bottomStackContainer.layer.borderColor = UIColor.white.cgColor
        bottomStackContainer.layer.cornerRadius = 8.0
        bottomStackContainer.clipsToBounds = true
        
        // bottom stack view content
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.font = UIFont.systemFont(ofSize: 45)
        cityTextField.textAlignment = .center
        cityTextField.textColor = UIColor.gray
        cityTextField.isUserInteractionEnabled = true
        cityTextField.placeholder = "Enter city"
        cityTextField.borderStyle = .roundedRect
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        // bottomWeatherInfoStackView - min, max temp + humidity labels
        bottomWeatherTempInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomWeatherTempInfoStackView.axis = .horizontal
        bottomWeatherTempInfoStackView.alignment = .center
        bottomWeatherTempInfoStackView.spacing = 15
        
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        minTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    }
    
    private func setupLayout() {
        view.addSubview(backgroundView)
        view.addSubview(rootStackView)
        view.addSubview(locationButton)
        
        rootStackView.addSubview(topStackView)
        rootStackView.addSubview(bottomStackContainer)
        
        topStackView.addArrangedSubview(topWeatherStackView)
        topStackView.addArrangedSubview(weatherImageView)
        
        topWeatherStackView.addArrangedSubview(temperatureLabel)
        topWeatherStackView.addArrangedSubview(weatherDescriptionLabel)
        
        bottomStackContainer.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(cityTextField)
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(bottomWeatherTempInfoStackView)
        
        bottomWeatherTempInfoStackView.addArrangedSubview(minTempLabel)
        bottomWeatherTempInfoStackView.addArrangedSubview(maxTempLabel)
        bottomStackView.addArrangedSubview(humidityLabel)
        
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
            locationButton.heightAnchor.constraint(equalToConstant: 35),
            weatherImageView.heightAnchor.constraint(equalToConstant: 100),
            weatherImageView.widthAnchor.constraint(equalToConstant: 100)
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
            self?.temperatureLabel.text = self?.weatherViewModel.temperatureString
            self?.weatherDescriptionLabel.text = self?.weatherViewModel.weatherDescriptionString
            self?.cityTextField.text = self?.weatherViewModel.cityTextFieldString
            self?.dateLabel.text = self?.weatherViewModel.todayDateString
            self?.minTempLabel.text = self?.weatherViewModel.minTempString
            self?.maxTempLabel.text = self?.weatherViewModel.maxTempString
            self?.humidityLabel.text = self?.weatherViewModel.humidityString
            self?.weatherImageView.image = UIImage(systemName: self?.weatherViewModel.weatherImageIconName ?? "")
            self?.weatherImageView.tintColor = self?.weatherViewModel.weatherImageIconColor
        }
    }
    
    // Hide the keyboard and fetch weather data when user taps the view
    @objc internal func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let tapLocation = sender.location(in: view)
            if !cityTextField.frame.contains(tapLocation) {
                view.endEditing(true)
                weatherViewModel.fetchWeatherData(city: cityTextField.text ?? "")
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
                self?.cityTextField.text = ""
            }
        }
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cityTextField {
            weatherViewModel.fetchWeatherData(city: textField.text ?? "")
            textField.resignFirstResponder()
            
            return true
        }
        return false
    }
}
