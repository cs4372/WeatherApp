//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/4/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
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
    let cityLabel = UILabel()
    let dateLabel = UILabel()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    let humidityLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .green
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .horizontal
        topStackView.spacing = 10
        topStackView.alignment = .top
        
        topWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
//        topWeatherStackView.alignment = .leading
        topWeatherStackView.axis = .vertical
        topWeatherStackView.spacing = 10
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 100)
        temperatureLabel.tintColor = .label
        temperatureLabel.text = "12"
        
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        weatherDescriptionLabel.text = "Sunny"
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.image = UIImage(systemName: "sun.max")
        weatherImageView.tintColor = .label
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .center
        bottomStackView.spacing = 10
        
        // bottom stack view content
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        cityLabel.text = "New York"
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        dateLabel.text = "July 4"
        
        // bottomWeatherInfoStackView - min, max temp + humidity labels
        bottomWeatherInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomWeatherInfoStackView.axis = .horizontal
        bottomWeatherInfoStackView.alignment = .center
        bottomWeatherInfoStackView.spacing = 10
        
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        minTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        minTempLabel.text = "L:13"
        
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        maxTempLabel.text = "H:21"
        
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        humidityLabel.text = "84"
    }
    
    private func setupLayout() {
        view.addSubview(rootStackView)
        
        rootStackView.addSubview(topStackView)
        rootStackView.addSubview(bottomStackView)
        
        topStackView.addArrangedSubview(topWeatherStackView)
        topStackView.addArrangedSubview(weatherImageView)
        
        topWeatherStackView.addArrangedSubview(temperatureLabel)
        topWeatherStackView.addArrangedSubview(weatherDescriptionLabel)
        
        bottomStackView.addArrangedSubview(cityLabel)
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(bottomWeatherInfoStackView)
        
        bottomWeatherInfoStackView.addArrangedSubview(minTempLabel)
        bottomWeatherInfoStackView.addArrangedSubview(maxTempLabel)
        bottomWeatherInfoStackView.addArrangedSubview(humidityLabel)
                        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 2),
            rootStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            topStackView.topAnchor.constraint(equalToSystemSpacingBelow: rootStackView.topAnchor, multiplier: 2),
            topStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            bottomStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomStackView.bottomAnchor, multiplier: 5),
            weatherImageView.heightAnchor.constraint(equalToConstant: 120),
            weatherImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
