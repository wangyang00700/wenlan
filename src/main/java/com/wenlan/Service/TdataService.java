package com.wenlan.Service;

import com.wenlan.Dao.TdataMapper;
import com.wenlan.Model.Tdata;
import com.wenlan.Model.TdataExample;
import com.wenlan.Model.User;
import com.wenlan.Utils.ExcelUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by 59100 on 2019/5/16.
 */
@Service
@Transactional
public class TdataService {

    @Autowired
    TdataMapper tdataMapper;
    @Autowired
    UserService userService;

    public Map<String, Object> getAll() {
        Map<String, Object> map = new HashMap<>();
        map.put("list", tdataMapper.selectByExample(new TdataExample()));
        map.put("code", 1);
        return map;
    }

    public Map<String, Object> queryTdataBySys(int page, int limit) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> data = new HashMap();
        data.put("page", (page - 1) * limit);
        data.put("limit", limit);
        List<Tdata> list = tdataMapper.queryTdataBySys(data);
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        map.put("count", tdataMapper.countByExample(new TdataExample()));
        TdataExample tdataExample = new TdataExample();
        tdataExample.or().andUidNotEqualTo(0);
        map.put("okcount", tdataMapper.countByExample(tdataExample));
        return map;
    }

    public Map<String, Object> queryTdataByUser(int page, int limit, int uid) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> data = new HashMap();
        data.put("page", (page - 1) * limit);
        data.put("limit", limit);
        data.put("uid", uid);
        List<Tdata> list = tdataMapper.queryTdataByUser(data);
        map.put("code", 0);
        map.put("data", list);
        map.put("limit", limit);
        TdataExample tdataExample = new TdataExample();
        tdataExample.or().andUidEqualTo(uid);
        map.put("count", tdataMapper.countByExample(tdataExample));
//        TdataExample tdataExample = new TdataExample();
//        tdataExample.or().andUidNotEqualTo(0);
//        map.put("okcount", tdataMapper.countByExample(tdataExample));
        return map;
    }

    public Map<String, Object> queryTdataByUserAll(int uid) {
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> data = new HashMap();
        data.put("uid", uid);
        List<Tdata> list = tdataMapper.queryTdataByUserAll(data);
        map.put("code", 1);
        map.put("data", list);
        return map;
    }

    public Map<String, Object> setTdataByuid(int uid) {
        User user = userService.getUser(uid);
        //当用户提取量不够时
        if (user.getCount() == 0) {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 0);
            map.put("msg", "用户提取量不足,请联系管理员充值");
            return map;
        }
        List<Tdata> tdatas = null;
        TdataExample tdataExample = new TdataExample();
        tdataExample.or().andUidEqualTo(0);
        tdatas = tdataMapper.selectByExample(tdataExample);
        if (tdatas.size() < user.getCount()) {
            Map<String, Object> map = new HashMap<>();
            map.put("code", 0);
            map.put("msg", "库存不够,请联系管理员补充");
            return map;
        }

        int datacount = user.getCount();
        for (int i = 0; i < tdatas.size() && datacount > 0; i++) {
            tdatas.get(i).setUid(uid);
            if (tdataMapper.updateByPrimaryKey(tdatas.get(i)) == 1)
                datacount--;
        }

        user.setCount(datacount);
        userService.updateUser(user);

        Map<String, Object> map = new HashMap<>();
        map.put("code", 1);
        map.put("msg", "获取成功");
        return map;
    }

    public Map<String, Object> delete(int type) {
        Map<String, Object> map = new HashMap<>();
        //删除所有数据
        if (type == 0) {
            tdataMapper.deleteByExample(new TdataExample());
        }
        //删除已提取数据
        else if (type == 1) {
            TdataExample TdataExample = new TdataExample();
            TdataExample.or().andUidNotEqualTo(0);
            tdataMapper.deleteByExample(TdataExample);
        }
        map.put("code", 1);
        return map;
    }

    /*******************************************************************************/

    //解析Excel
    public Map<String, Object> ajaxUploadExcel(MultipartFile file) {
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
        try {
            listob = new ExcelUtils().getBankListByExcel(in, file.getOriginalFilename());
            List<Tdata> tdatas = new ArrayList<>();
            for (int i = 0; i < listob.size(); i++) {
                List<Object> lo = listob.get(i);
                Tdata tdata = new Tdata();
                tdata.setName(String.valueOf(lo.get(0)));
                tdata.setTel(String.valueOf(lo.get(1)));
                tdata.setUid(0);
                tdata.setStatus(0);
                tdata.setVersion("1");
                tdatas.add(tdata);
            }
            tdataMapper.insertSome(tdatas);
            map.put("code", 1);
            map.put("text", "导入成功");
        } catch (Exception e) {
            e.printStackTrace();
            map.put("code", 0);
            map.put("text", e.getMessage());
        }
        return map;
    }

    /*******************************************************************************/
}
