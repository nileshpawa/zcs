/*
 * ***** BEGIN LICENSE BLOCK *****
 * Zimbra Collaboration Suite Web Client
 * Copyright (C) 2012, 2013, 2014, 2016 Synacor, Inc.
 *
 * The contents of this file are subject to the Common Public Attribution License Version 1.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: https://www.zimbra.com/license
 * The License is based on the Mozilla Public License Version 1.1 but Sections 14 and 15
 * have been added to cover use of software over a computer network and provide for limited attribution
 * for the Original Developer. In addition, Exhibit A has been modified to be consistent with Exhibit B.
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied.
 * See the License for the specific language governing rights and limitations under the License.
 * The Original Code is Zimbra Open Source Web Client.
 * The Initial Developer of the Original Code is Zimbra, Inc.  All rights to the Original Code were
 * transferred by Zimbra, Inc. to Synacor, Inc. on September 14, 2015.
 *
 * All portions of the code are Copyright (C) 2012, 2013, 2014, 2016 Synacor, Inc. All Rights Reserved.
 * ***** END LICENSE BLOCK *****
 */

UT.module("Speed");

UT.test("bind() vs AjxListener",
	
	function() {
		var func = function(x) { var a = x + 2; };
		var num = 100000;
		var s = new Date();
		var list = [];
		for (var i = 0; i < num; i++) {
			list.push(new AjxListener(null, func, i));
		}
		var e = new Date();
		console.log("AjxListener, " + num + " iterations: " + (e.getTime() - s.getTime()));
		
		var list = [];
		var s = new Date();
		for (var i = 0; i < num; i++) {
			list.push(func.bind(null, i));
		}
		var e = new Date();
		console.log("Bind, " + num + " iterations: " + (e.getTime() - s.getTime()));
	}
);
