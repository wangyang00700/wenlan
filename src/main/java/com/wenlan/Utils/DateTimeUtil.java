package com.wenlan.Utils;

import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 日期时间工具类
 *
 * @author 肖浩
 * @date 2015年8月26日
 */
@Component
public class DateTimeUtil {

    public static String getDate() {
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd");
        Date date = new Date();
        String date1 = sf.format(date);
        return date1;
    }

    public static String getCurrentDate(String aFormat) {
        String tDate = new SimpleDateFormat(aFormat).format(new Date(
                System.currentTimeMillis()));
        return tDate;
    }

    public static String getCurrentDate() {
        return DateTimeUtil.getCurrentDate("yyyyMMdd");
    }

    public static String getCurrentDate3() {
        return DateTimeUtil.getCurrentDate("yyyy/MM/dd");
    }

    public static String getCurrentDate2() {
        return DateTimeUtil.getCurrentDate("yyyyMM");
    }

    public static String getCurrentTime() {
        return DateTimeUtil.getCurrentDate("HHmmss");
    }

    public static String getCurrentDateAndTime() {
        return DateTimeUtil.getCurrentDate("yyyyMMddHHmmss");
    }

    public static String getCurrentDateAndTime2() {
        return DateTimeUtil.getCurrentDate("yyyy-MM-dd HH-mm-ss");
    }

    public static Calendar getBeforeHourTime(int hour) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Calendar calendar = Calendar.getInstance();
        //往前推hour小时
        calendar.add(Calendar.HOUR, -hour);
        return calendar;
    }

    public static String getNextMinuteTime(Calendar calendar, int minute) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        calendar.add(Calendar.MINUTE, minute);
        return df.format(calendar.getTime());
    }

    public static String getNewRandomCode(int codeLen) {
        // 首先定义随机数据源
        // 根据需要得到的数据码的长度返回随机字符串
        java.util.Random randomCode = new java.util.Random();
        String strCode = "";
        while (codeLen > 0) {
            int charCode = randomCode.nextInt(9);
            strCode += charCode;
            codeLen--;
        }
        return strCode;
    }
}
