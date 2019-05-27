package com.wenlan.Service;

import com.github.pagehelper.PageHelper;
import com.wenlan.Dao.ClientMapper;
import com.wenlan.Dao.UserMapper;
import com.wenlan.Model.*;
import com.wenlan.Utils.DateTimeUtil;
import com.wenlan.Utils.ExcelUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import javax.xml.crypto.Data;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by 59100 on 2019/5/16.
 */
@Service
@Transactional
public class ClientService {

    @Autowired
    ClientMapper clientMapper;
    @Autowired
    UserService userService;

    public Map<String, Object> getAll() {
        Map<String, Object> map = new HashMap<>();
        map.put("list", clientMapper.selectByExample(new ClientExample()));
        map.put("code", 1);
        return map;
    }

    //管理员获取所有实时表资料
    public Map<String, Object> queryClientsBySys(int page, int limit) {
        Map<String, Object> map = new HashMap<>();
        PageHelper.startPage(page, limit);
        ClientExample clientExample = new ClientExample();
        clientExample.setOrderByClause("date");
        List<Client> list = clientMapper.selectByExample(clientExample);
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        map.put("count", clientMapper.countByExample(new ClientExample()));
        clientExample = new ClientExample();
        clientExample.or().andUidNotEqualTo(0);
        map.put("okcount", clientMapper.countByExample(clientExample));
        return map;
    }

    //用户查看所有未购买客户资料
    public Map<String, Object> queryAllByUser(int page, int limit) {
        Map<String, Object> map = new HashMap<>();
        ClientExample clientExample = new ClientExample();
        clientExample.or().andUidEqualTo(0);
        clientExample.setOrderByClause("date");
        PageHelper.startPage(page, limit);
        List<Client> list = clientMapper.selectByExample(clientExample);
        String time = DateTimeUtil.getCurrentDate3();
        for (Client item : list) {
            String tel = item.getTel();
            item.setTel(tel.substring(0, 3) + "****" + tel.substring(7, tel.length()));
            if (item.getDate().equals(time)) {
                item.setDate("今天");
            }
        }
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        map.put("count", clientMapper.countByExample(clientExample));
        return map;
    }

    public Map<String, Object> queryClientsByUser(int page, int limit, int uid) {
        Map<String, Object> map = new HashMap<>();
        ClientExample clientExample = new ClientExample();
        clientExample.or().andUidEqualTo(uid);
        clientExample.setOrderByClause("date");
        PageHelper.startPage(page, limit);
        List<Client> list = clientMapper.selectByExample(clientExample);
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        map.put("count", clientMapper.countByExample(clientExample));
        return map;
    }

    //导出时获取该用户所有客户
    public Map<String, Object> queryClientsByUserAll(int uid) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> data = new HashMap();
        data.put("uid", uid);
        List<DataSimple> list = clientMapper.queryClientsByUserAll(data);
        map.put("code", 1);
        map.put("data", list);
        return map;
    }

    public Map<String, Object> setClientByuid(int uid, String cids) {
        User user = userService.getUser(uid);
        //当用户提取量不够时
        if (user.getCount() <= 0) {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 0);
            map.put("msg", "用户提取量不足,请联系管理员充值");
            return map;
        }
        cids = cids.substring(1);
        String datas[] = cids.split(",");
        if (datas.length > user.getCount()) {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 0);
            map.put("msg", "提取量不足" + datas.length + ",请重新选择客户");
            return map;
        }
        List<String> list = new ArrayList<>();
        for (String s : datas) {
            list.add(s);
        }
        List<DataUModel> data = clientMapper.queryClientsByUserLitle(list);
        for (DataUModel model : data) {
            model.setUid(uid);
        }
        clientMapper.updateSome(data);
        data = clientMapper.queryClientsByUserLitle(list);
        int upCount = 0;
        for (DataUModel model : data) {
            if (model.getUid() == uid)
                upCount++;
        }
        user.setCount(user.getCount() - upCount);
        userService.updateUser(user);
        if (upCount < datas.length) {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 2);
            map.put("msg", "购买部分成功,剩余请看提取量");
            return map;
        } else {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 1);
            map.put("msg", "购买成功");
            return map;
        }
    }

    public Map<String, Object> delete(int type) {
        Map<String, Object> map = new HashMap<>();
        //删除所有数据
        if (type == 0) {
            clientMapper.deleteByExample(new ClientExample());
        }
        //删除已提取数据
        else if (type == 1) {
            ClientExample clientExample = new ClientExample();
            clientExample.or().andUidNotEqualTo(0);
            clientMapper.deleteByExample(clientExample);
        }
        map.put("code", 1);
        return map;
    }

    /*******************************************************************************/

    //解析Excel
    public Map<String, Object> ajaxUploadExcel(MultipartFile file, String startDate, String endDate) {
        Map<String, Object> map = new HashMap<>();
        if (file.isEmpty()) {
            try {
                throw new Exception("文件不存在！");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        InputStream in = null;
        try {
            in = file.getInputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }

        List<List<Object>> listob = null;
        List<Client> clients = new ArrayList<>();
        try {
            listob = new ExcelUtils().getBankListByExcel(in, file.getOriginalFilename());
            //获取两个时间相差秒数
            long minute = DateTimeUtil.datediff(startDate, endDate);
            if (minute <= 0) {
                map.put("code", 0);
                map.put("text", "时间一样或开始时间大于结束时间");
                return map;
            }

            Calendar calendar = DateTimeUtil.getCalendar(startDate);
            String datetime = DateTimeUtil.getNextMinuteTime(calendar, 0);
            Random r = new Random();
            int bount = (int) (listob.size() / minute);
            if (bount == 0) bount = 1;
            for (int i = 0; i < listob.size(); i++) {
                List<Object> lo = listob.get(i);
                Client client = new Client();
                client.setName(String.valueOf(lo.get(0)));
                client.setTel(String.valueOf(lo.get(1)));
                client.setUid(0);
                client.setStatus(0);
                client.setVersion("1");
                if ((i + 1) % bount == 0) {
                    datetime = DateTimeUtil.getNextMinuteTime(calendar, 1);
                }
                int i1 = r.nextInt(58) + 1;
                String time = "";
                if (i1 > 9) time = datetime + ":" + i1;
                else time = datetime + ":0" + i1;
                client.setDate(time);
                clients.add(client);
            }
            clientMapper.insertSome(clients);
            map.put("code", 1);
            map.put("text", "导入成功");
        } catch (Exception e) {
            e.printStackTrace();
            map.put("code", 0);
            map.put("text", "格式有误，请另存为一份新文档上传");
        }
        return map;
    }

    /*******************************************************************************/
}
