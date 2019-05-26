package com.wenlan.Utils;

import org.springframework.stereotype.Component;

import java.text.ParseException;
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

    public static long datediff(String startTime, String endTime) {
        SimpleDateFormat dfs = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        try {
            Date begin = dfs.parse(startTime);
            Date end = dfs.parse(endTime);
            long between = (end.getTime() - begin.getTime()) / 1000;//除以1000是为了转换成秒
            return between;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static Long dateDiff(String startTime, String endTime,
                                String format, String str) {
        // 按照传入的格式生成一个simpledateformate对象
        SimpleDateFormat sd = new SimpleDateFormat(format);
        long nd = 1000 * 24 * 60 * 60;// 一天的毫秒数
        long nh = 1000 * 60 * 60;// 一小时的毫秒数
        long nm = 1000 * 60;// 一分钟的毫秒数
        long ns = 1000;// 一秒钟的毫秒数
        long diff;
        long day = 0;
        long hour = 0;
        long min = 0;
        long sec = 0;
        // 获得两个时间的毫秒时间差异
        try {
            diff = sd.parse(endTime).getTime() - sd.parse(startTime).getTime();
            day = diff / nd;// 计算差多少天
            hour = diff % nd / nh + day * 24;// 计算差多少小时
            min = diff % nd % nh / nm + day * 24 * 60;// 计算差多少分钟
            sec = diff % nd % nh % nm / ns + day * 24 * 60 * 60;// 计算差多少秒
            // 输出结果
            System.out.println("时间相差：" + day + "天" + (hour - day * 24) + "小时"
                    + (min - day * 24 * 60) + "分钟" + (sec - day * 24 * 60 * 60) + "秒。");
            if (str.equalsIgnoreCase("h")) {
                return hour;
            } else {
                return min;
            }

        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        if (str.equalsIgnoreCase("h")) {
            return hour;
        } else {
            return min;
        }
    }
}
