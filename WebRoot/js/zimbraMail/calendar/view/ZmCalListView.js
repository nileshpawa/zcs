/*
 * ***** BEGIN LICENSE BLOCK *****
 *
 * Zimbra Collaboration Suite Web Client
 * Copyright (C) 2004, 2005, 2006, 2007 Zimbra, Inc.
 *
 * The contents of this file are subject to the Yahoo! Public License
 * Version 1.0 ("License"); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://www.zimbra.com/license.
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
 *
 * ***** END LICENSE BLOCK *****
 */

ZmCalListView = function(parent, posStyle, controller, dropTgt) {
	if (arguments.length == 0) { return; }

	var params = {
		parent: parent,
		posStyle: posStyle,
		controller: controller,
		dropTgt: dropTgt,
		view: ZmId.VIEW_CAL_LIST,
		headerList: this._getHeaderList(parent)
	}

	ZmListView.call(this, params);

	this._needsRefresh = true;
	this._timeRangeStart = 0;
	this._timeRangeEnd = 0;
	this._currentIdForTooltip = {};
	this._title = "";
};

ZmCalListView.prototype = new ZmListView;
ZmCalListView.prototype.constructor = ZmCalListView;


// Consts
ZmCalListView.DEFAULT_CALENDAR_PERIOD	= AjxDateUtil.MSEC_PER_DAY*14;			// 14 days
ZmCalListView.DEFAULT_SEARCH_PERIOD		= AjxDateUtil.MSEC_PER_DAY*31;			// 31 days
ZmCalListView.COL_WIDTH_DATE			= 105;
ZmCalListView.COL_WIDTH_LOCATION		= 175;
ZmCalListView.COL_WIDTH_STATUS			= 80;


// Public methods

ZmCalListView.prototype.toString =
function() {
	return "ZmCalListView";
};


// ZmCalBaseView methods

ZmCalListView.prototype.getTimeRange =
function() {
	return { start:this._timeRangeStart, end:this._timeRangeEnd };
};

ZmCalListView.prototype.getTitle =
function() {
	return [ZmMsg.zimbraTitle, this.getCalTitle()].join(": ");
};

ZmCalListView.prototype.getCalTitle =
function() {
	return this._title;
};

ZmCalListView.prototype.needsRefresh =
function() {
	return this._needsRefresh;
};

ZmCalListView.prototype.setNeedsRefresh =
function(needsRefresh) {
	this._needsRefresh = needsRefresh;
};

ZmCalListView.prototype.getDate =
function() {
	return this._date;
};

ZmCalListView.prototype.setDate =
function(date, duration, roll) {
//	this._duration = duration; // necessary?
	this._date = new Date(date.getTime());

	var d = new Date(date.getTime());
	d.setHours(0, 0, 0, 0);
	this._timeRangeStart = d.getTime();
	this._timeRangeEnd = d.getTime() + ZmCalListView.DEFAULT_CALENDAR_PERIOD;

	this._updateTitle();
};

ZmCalListView.prototype.getRollField =
function() {
	return AjxDateUtil.MONTH;
};

ZmCalListView.prototype._fanoutAllDay =
function(appt) {
	return false;
};

ZmCalListView.prototype._apptSelected =
function() {
	// do nothing
};

ZmCalListView.prototype._updateTitle =
function() {
	var dayFormatter = DwtCalendar.getDayFormatter();
	var start = new Date(this._timeRangeStart);
	var end = new Date(this._timeRangeEnd);

	this._title = [
		dayFormatter.format(start), " - ", dayFormatter.format(end)
	].join("");
};


// DwtListView methods

ZmCalListView.prototype._getFieldId =
function(item, field) {
	return DwtId.getListViewItemId(DwtId.WIDGET_ITEM_FIELD, this._view, item.getUniqueId(true), field);
};

ZmCalListView.prototype._getCellId =
function(item, field) {
	if (field == ZmItem.F_SUBJECT ||
		field == ZmItem.F_DATE)
	{
		return this._getFieldId(item, field);
	}
};

ZmCalListView.prototype._getCellContents =
function(htmlArr, idx, appt, field, colIdx, params) {
	if (field == ZmItem.F_SELECTION) {
		var icon = params.bContained ? "TaskCheckboxCompleted" : "TaskCheckbox";
		idx = this._getImageHtml(htmlArr, idx, icon, this._getFieldId(appt, field));

	} else if (field == ZmItem.F_RECURRENCE) {
		var icon;
		if (appt.isException) {
			icon = "ApptException";
		} else if (appt.isRecurring()) {
			icon = "ApptRecur";
		}
		idx = this._getImageHtml(htmlArr, idx, icon, this._getFieldId(appt, field));

	} else if (field == ZmItem.F_SUBJECT) {
		if (params.isMixedView) {
			htmlArr[idx++] = appt.name ? AjxStringUtil.htmlEncode(appt.name, true) : AjxStringUtil.htmlEncode(ZmMsg.noSubject);
		} else {
			htmlArr[idx++] = AjxStringUtil.htmlEncode(appt.getName(), true);
		}
		if (appCtxt.get(ZmSetting.SHOW_FRAGMENTS) && appt.fragment) {
			htmlArr[idx++] = this._getFragmentSpan(appt);
		}

	} else if (field == ZmItem.F_LOCATION) {
		htmlArr[idx++] = AjxStringUtil.htmlEncode(appt.getLocation(), true);

	} else if (field == ZmItem.F_STATUS) {
		if (appt.otherAttendees) {
			htmlArr[idx++] = appt.getParticipantStatusStr();
		}
	} else if (field == ZmItem.F_DATE) {
		htmlArr[idx++] = (appt.isAllDayEvent())
			? AjxMessageFormat.format(ZmMsg.apptDateTimeAllDay, [appt.startDate])
			: AjxMessageFormat.format(ZmMsg.apptDateTime, [appt.startDate, appt.startDate]);

	} else {
		idx = ZmListView.prototype._getCellContents.apply(this, arguments);
	}

	return idx;
};

ZmCalListView.prototype._mouseOverAction =
function(ev, div) {
	DwtListView.prototype._mouseOverAction.call(this, ev, div);
	var id = ev.target.id || div.id;
	if (!id) { return true; }

	// check if we're hovering over a column header
	var data = this._data[div.id];
	var type = data.type;
	if (type && type == DwtListView.TYPE_HEADER_ITEM) {
		var itemIdx = data.index;
		var field = this._headerList[itemIdx]._field;
		this.setToolTipContent(this._getHeaderToolTip(field, itemIdx));
	} else {
		var item = this.getItemFromElement(div);
		if (item) {
			this.setToolTipContent(item.getToolTip(this._controller));

			// load attendee status if necessary
			if (item.otherAttendees &&
				(item._ptstHashMap == null) &&
				(!this._currentIdForTooltip[item.id]))
			{
				var obj = DwtControl.getTargetControl(ev);
				var clone = ZmAppt.quickClone(item);
				this._currentIdForTooltip[item.id] = true; // used to prevent processing multiple times
				var callback = new AjxCallback(null, ZmApptViewHelper.refreshApptTooltip, [this, clone, item, obj]);
				AjxTimedAction.scheduleAction(new AjxTimedAction(clone, clone.getDetails, [null, callback, null, null, true]), 2000);
			}
		}
	}
	return true;
};

ZmCalListView.prototype._getHeaderToolTip =
function(field, itemIdx) {
	switch (field) {
		case ZmItem.F_LOCATION: return ZmMsg.location;
		case ZmItem.F_FOLDER:	return ZmMsg.calendar;
		case ZmItem.F_DATE:		return ZmMsg.date;
	}
	return ZmListView.prototype._getHeaderToolTip.call(this, field, itemIdx);
};

ZmCalListView.prototype._getHeaderList =
function(parent) {
	var hList = [];

	if (appCtxt.get(ZmSetting.SHOW_SELECTION_CHECKBOX)) {
		hList.push(new DwtListHeaderItem({field:ZmItem.F_SELECTION, icon:"TaskCheckbox", width:ZmListView.COL_WIDTH_ICON, name:ZmMsg.selection}));
	}
	if (appCtxt.get(ZmSetting.TAGGING_ENABLED)) {
		hList.push(new DwtListHeaderItem({field:ZmItem.F_TAG, icon:"Tag", width:ZmListView.COL_WIDTH_ICON, name:ZmMsg.tag}));
	}
	hList.push(new DwtListHeaderItem({field:ZmItem.F_ATTACHMENT, icon:"Attachment", width:ZmListView.COL_WIDTH_ICON, name:ZmMsg.attachment}));
	hList.push(new DwtListHeaderItem({field:ZmItem.F_SUBJECT, text:ZmMsg.subject, noRemove:true}));
	hList.push(new DwtListHeaderItem({field:ZmItem.F_LOCATION, text:ZmMsg.location, width:ZmCalListView.COL_WIDTH_LOCATION, resizeable:true}));
	hList.push(new DwtListHeaderItem({field:ZmItem.F_STATUS, text:ZmMsg.status, width:ZmCalListView.COL_WIDTH_STATUS, resizeable:true}));
	hList.push(new DwtListHeaderItem({field:ZmItem.F_RECURRENCE, icon:"ApptRecur", width:ZmListView.COL_WIDTH_ICON, name:ZmMsg.recurrence}));
	hList.push(new DwtListHeaderItem({field:ZmItem.F_DATE, text:ZmMsg.startDate, width:ZmCalListView.COL_WIDTH_DATE, sortable:ZmItem.F_DATE}));

	return hList;
};
