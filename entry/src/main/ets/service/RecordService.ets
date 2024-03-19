import RecordPO from '../common/bean/RecordPO'
import RecordVO from '../common/bean/RecordVO'
import DateUtil from '../common/utils/DateUtil'
import ItemModel from '../model/ItemModel'
import RecordModel from '../model/RecordModel'
import RecordItem from '../viewmodel/RecordItem'
import { RecordTypeEnum } from '../viewmodel/RecordTypeModel'


class RecordService {

  // 新增数据
  insert(typeId: number, itemId: number, amount: number): Promise<number> {
    // 获取存储的时间
    let createTime: number = AppStorage.Get('selectedData') || DateUtil.beginTimeOfDay(new Date())
    // 新增
    return RecordModel.insert({ typeId: typeId, itemId: itemId, amount: amount, createTime: createTime })
  }

  //根据Id删除数据
  deleteById(id: number): Promise<number> {
    return RecordModel.deleteById(id)
  }

  // 根据日期查询数据
  async queryRecordByDate(date: number): Promise<RecordVO[]> {
    // 获取查询的结果
    let recordPos = await  RecordModel.listByDate(date)
    // 将PO转成Vo
    return recordPos.map(po => {
      // 2.1.获取po中的基本属性
      let vo = { id: po.id, typeId: po.typeId, amount: po.amount } as RecordVO
      // 2.2查询记录项
      vo.recordItem = ItemModel.getById(po.id)
      // 2.3.计算热量
      vo.calorie = po.amount * vo.recordItem.calorie
      return vo
    })
  }
}