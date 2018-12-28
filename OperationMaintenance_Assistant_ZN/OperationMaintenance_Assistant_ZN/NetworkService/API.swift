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
//修改密码
public let getModifyPasswordUrl = baseURL + "/my/getModifyPassword"
//获取用户信息
public let getSysUserUrl = baseURL + "/user/getSysUser"

//字典表下载
public let getDatesUrl = baseURL + "/meter/getDates"
//抄表验证并返回表底数
public let getVerificationUrl = baseURL + "/meter/getVerification"
//抄表查询设备信息(扫码)
public let getDeviceInfoUrl = baseURL + "/meter/getDeviceInfo"
//抄表提交数据
public let getSubmitUrl = baseURL + "/meter/getSubmit"
//换表
public let getDateUrl = baseURL + "/change/getDate"
//用户上传头像
public let getModifyAvatarUrl = baseURL + "/my/getModifyAvatar"
//首页维修头条接口
public let getTheHeadlinesUrl = baseURL + "/first/getTheHeadlines"
//首页工单维修情况接口
public let getJobOrderUrl = baseURL + "/first/getJobOrder"

//记录
public let getRecordUrl = baseURL + "/record/getDate"
//抄表获取数据
public let getDisplayUrl = baseURL + "/meter/getDisplay"
//抄表删除数据
public let getDeleteUrl = baseURL + "/meter/getDelete"
