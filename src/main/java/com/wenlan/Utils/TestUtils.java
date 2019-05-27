package com.wenlan.Utils;

/**
 * Created by Administrator on 2019/5/26.
 */
public class TestUtils {
    public static void main(String[] agrs) {
        String s1 = "2019/05/27 10:20";
        String s2 = "2019/05/27 12:00";
        System.out.println(DateTimeUtil.datediff(s1,s2));
    }
}
