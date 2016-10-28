# KernLabel

[![Build Status](https://travis-ci.org/ikait/KernLabel.svg?branch=master)](https://travis-ci.org/ikait/KernLabel)
[![CocoaPods](https://img.shields.io/cocoapods/v/KernLabel.svg?maxAge=2592000)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](http://img.shields.io/:license-MIT-blue.svg)](http://doge.mit-license.org)

KernLabel is a UILabel replacement to show mainly Japanese texts kerning applied for readability.

KernLabel は、主に日本語で書かれたテキストをカーニングし、可読性を向上させて表示するための UILabel 代替です。
現在は約物系のみのカーニングに対応しています。

![Sample 1](https://github.com/ikait/KernLabel/raw/master/images/sample1.png)


## Requirements

* iOS 8.0+
* Xcode 8.0+
* Swift 3.0+

## Install

You can install KernLabel to your project via CocoaPods or Carthage.

### CocoaPods

Add the following line to Podfile:

```
use_frameworks!

pod 'KernLabel', '~> 0.5.0'
```

### Carthage

Add the following line to Carthage:

```
github "ikait/KernLabel" == 0.5.0
```

## Usage

```swift
let label = KernLabel()
label.text = "「あいうえお」"
view.addSubview(label)
```

UILabel にある一部のプロパティに加えて、以下のプロパティを利用できます。

### Kerning Mode

カーニングを行う対象を指定します。

```swift
label.kerningMode = .minimum
```

* `.none`: 行頭の始め括弧系のみを詰める
* `.minimum`: 上に加え、連続する括弧系を詰める
* `.normal`: 上に加え、括弧系を全て詰める
* `.all`: 上に加え、句読点を全て詰める

### Vertical Alignment

ラベル内において、文字列が配置される縦位置を指定します。

```swift
label.verticalAlignment = .top
```

* `.top`: 上揃え
* `.middle`: 中央揃え
* `.bottom`: 下揃え
