//
//  API.swift
//  swift_test
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 chenxianghong. All rights reserved.
//

import Foundation



//public struct API {

private let baseURL = "http://plat.znxk.net:6801"

//private let baseURL = "http://"    //


//MARK:- ---  接口

//登录
public let LoginUrl = baseURL + "/first/getLand"
//找回密码接口
public let getBackPasswordUrl = baseURL + "/first/getBackPassword"

//字典表下载
public let getDatesUrl = baseURL + "/meter/getDates"
//抄表验证并返回表底数
public let getVerificationUrl = baseURL + "/meter/getVerification"
//抄表查询设备信息(扫码)
public let getDeviceInfoUrl = baseURL + "/meter/getDeviceInfo"
//抄表提交数据
public let getSubmitUrl = baseURL + "/meter/getSubmit"
//换表
public let getSubmitUrl = baseURL + "/change/getDate"
