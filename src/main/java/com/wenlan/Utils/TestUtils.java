package com.wenlan.Utils;

/**
 * Created by Administrator on 2019/5/26.
 */
public class TestUtils {
    public static void main(String[] agrs) {
        String s1 = "2019/05/26 9:00:00";
        String s2 = "2019/05/26 11:00:00";
        System.out.println(DateTimeUtil.datediff(s1,s2));
    }
}
