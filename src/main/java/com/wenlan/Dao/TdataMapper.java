package com.wenlan.Dao;

import com.wenlan.Model.DataSimple;
import com.wenlan.Model.Tdata;
import com.wenlan.Model.TdataExample;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.stereotype.Repository;

@MapperScan
@Repository
public interface TdataMapper {
    int countByExample(TdataExample example);

    int deleteByExample(TdataExample example);

    int deleteByPrimaryKey(Integer tdid);

    int insert(Tdata record);

    int insertSelective(Tdata record);

    List<Tdata> selectByExample(TdataExample example);

    Tdata selectByPrimaryKey(Integer tdid);

    int updateByExampleSelective(@Param("record") Tdata record, @Param("example") TdataExample example);

    int updateByExample(@Param("record") Tdata record, @Param("example") TdataExample example);

    int updateByPrimaryKeySelective(Tdata record);

    int updateByPrimaryKey(Tdata record);

    List<Tdata> queryTdataBySys(Map<String, Object> data);

    List<Tdata> queryTdataByUser(Map<String, Object> data);

    List<DataSimple> queryTdataByUserAll(Map<String, Object> data);

    int insertSome(List<Tdata> tdatas);
}