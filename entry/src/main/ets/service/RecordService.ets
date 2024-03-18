import RecordPO from '../common/bean/RecordPO'
import RecordVO from '../common/bean/RecordVO'
import DateUtil from '../common/utils/DateUtil'
import RecordModel from '../model/RecordModel'


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
  queryRecordByDate(date: number): Promise<RecordVO[]> {
    /*return new Promise((resolve, reject) => {
      RecordModel.listByDate(date)
        .then(recordPos => {
          let recordVos = recordPos.map(vo => { id: vo.id, typeId: vo.typeId, amount: vo.amount} as RecordVO)
          resolve()
        }).catch(err => {

      })
    })*/
    return null
  }
}