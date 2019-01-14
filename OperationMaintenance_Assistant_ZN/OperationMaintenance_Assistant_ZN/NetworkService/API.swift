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

//我的消息
public let getMyMessageUrl = baseURL + "/meter/getMyMessage"

//换表原因
public let changeReasonUrl = baseURL + "/change/getDate"



//获取报修类别
public let getRepairsClassUrl = baseURL + "/fieldRepairs/getRepairsClass"

//1.1.    1.1.    获取报修类型，根据报修类别
public let getRepairsTypeUrl = baseURL + "/fieldRepairs/getRepairsTypeByClass"
//1.1.    现场报修提交
public let commitUrl = baseURL + "/fieldRepairs/commit"

//工单首页 ,抢单池列表，我的工单整合接口:
public let getWorkFristUrl = baseURL + "/first/getWorkFrist"
//工单详情,抢单池详情，取消抢单
public let getDetailsUrl = baseURL + "/first/getDetails"
//抢单、抢单列表
public let getMyGrabListUrl = baseURL + "/my/getMyGrabList"

//public let getWorkFristUrl = baseURL + "/first/getWorkFrist"
//上传工单图片到本地服务器
public let getUploadPicturesURL = baseURL + "/first/getUploadPictures"


