//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/4/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private let weatherViewModel: WeatherViewModel
    
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
    let bottomWeatherInfoStackView = UIStackView()
    
    // top stack view content
    let temperatureLabel = UILabel()
    let weatherDescriptionLabel = UILabel()
    let weatherImageView = UIImageView()
    
    // bottom stack view content
    let bottomStackContainer = UIView()
    let cityTextField = UITextField()
    let dateLabel = UILabel()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    let humidityLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField.delegate = self
        
        setupUI()
        setupLayout()
                
        weatherViewModel.didUpdateCity = { [weak self] in
            self?.weatherViewModel.fetchWeatherData(city: self?.weatherViewModel.city ?? "")
        }
                
        weatherViewModel.didUpdateWeatherData = { [weak self] in
            self?.updateUI()
        }
    }
    
    private func setupUI() {
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        bottomStackView.spacing = 10
        
        bottomStackContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomStackContainer.layer.borderWidth = 5.0
        bottomStackContainer.layer.borderColor = UIColor.blue.cgColor
        bottomStackContainer.layer.cornerRadius = 8.0
        bottomStackContainer.clipsToBounds = true
        
        // bottom stack view content
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.font = UIFont.systemFont(ofSize: 45)
        cityTextField.placeholder = "Enter city"
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        // bottomWeatherInfoStackView - min, max temp + humidity labels
        bottomWeatherInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomWeatherInfoStackView.axis = .horizontal
        bottomWeatherInfoStackView.alignment = .center
        bottomWeatherInfoStackView.spacing = 10
        
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        minTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    }
    
    private func setupLayout() {
        view.addSubview(rootStackView)
        
        rootStackView.addSubview(topStackView)
        rootStackView.addSubview(bottomStackContainer)
        
        topStackView.addArrangedSubview(topWeatherStackView)
        topStackView.addArrangedSubview(weatherImageView)
        
        topWeatherStackView.addArrangedSubview(temperatureLabel)
        topWeatherStackView.addArrangedSubview(weatherDescriptionLabel)
        
        bottomStackContainer.addSubview(bottomStackView)
        
        bottomStackView.addArrangedSubview(cityTextField)
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(bottomWeatherInfoStackView)
        
        bottomWeatherInfoStackView.addArrangedSubview(minTempLabel)
        bottomWeatherInfoStackView.addArrangedSubview(maxTempLabel)
        bottomStackView.addArrangedSubview(humidityLabel)
                                
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 2),
            rootStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            topStackView.topAnchor.constraint(equalToSystemSpacingBelow: rootStackView.topAnchor, multiplier: 2),
            topStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.leadingAnchor, multiplier: 2),
            rootStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: topStackView.trailingAnchor, multiplier: 2),

            bottomStackContainer.centerXAnchor.constraint(equalTo: rootStackView.centerXAnchor),
            bottomStackContainer.centerYAnchor.constraint(equalTo: rootStackView.centerYAnchor),
            bottomStackContainer.leadingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.leadingAnchor, multiplier: 2),
            rootStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: bottomStackContainer.trailingAnchor, multiplier: 2),
            
            bottomStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: bottomStackContainer.leadingAnchor, multiplier: 2),
            bottomStackContainer.trailingAnchor.constraint(equalToSystemSpacingAfter: bottomStackView.trailingAnchor, multiplier: 2),
            bottomStackView.topAnchor.constraint(equalToSystemSpacingBelow: bottomStackContainer.topAnchor, multiplier: 2),
            bottomStackContainer.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomStackView.bottomAnchor, multiplier: 2),
            
            weatherImageView.heightAnchor.constraint(equalToConstant: 100),
            weatherImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.temperatureLabel.text = self?.weatherViewModel.temperatureString
            self?.weatherDescriptionLabel.text = self?.weatherViewModel.weatherDescriptionString
            self?.cityTextField.placeholder = self?.weatherViewModel.cityTextFieldString
            self?.dateLabel.text = self?.weatherViewModel.todayDateString
            self?.minTempLabel.text = self?.weatherViewModel.minTempString
            self?.maxTempLabel.text = self?.weatherViewModel.maxTempString
            self?.humidityLabel.text = self?.weatherViewModel.humidityString
            self?.weatherImageView.image = UIImage(systemName: self?.weatherViewModel.weatherImageIconName ?? "")
            self?.weatherImageView.tintColor = self?.weatherViewModel.weatherImageIconColor
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
