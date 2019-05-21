package com.wenlan.Dao;

import com.wenlan.Model.Client;
import com.wenlan.Model.ClientExample;

import java.util.List;
import java.util.Map;

import com.wenlan.Model.DataSimple;
import com.wenlan.Model.DataUModel;
import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.stereotype.Repository;

@MapperScan
@Repository
public interface ClientMapper {
    int countByExample(ClientExample example);

    int deleteByExample(ClientExample example);

    int deleteByPrimaryKey(Integer cid);

    int insert(Client record);

    int insertSelective(Client record);

    List<Client> selectByExample(ClientExample example);

    Client selectByPrimaryKey(Integer cid);

    int updateByExampleSelective(@Param("record") Client record, @Param("example") ClientExample example);

    int updateByExample(@Param("record") Client record, @Param("example") ClientExample example);

    int updateByPrimaryKeySelective(Client record);

    int updateByPrimaryKey(Client record);

    List<Client> queryClientsBySys(Map<String, Object> data);

    List<Client> queryClientsByUser(Map<String, Object> data);

    //导出用
    List<DataSimple> queryClientsByUserAll(Map<String, Object> data);

    //获取用
    List<DataUModel> queryClientsByUserLitle(Map<String, Object> data);

    int insertSome(List<Client> clients);

    int updateSome(List<DataUModel> clients);
}