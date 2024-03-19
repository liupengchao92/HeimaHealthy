import RecordPO from '../common/bean/RecordPO'
import RecordVO from '../common/bean/RecordVO'
import DateUtil from '../common/utils/DateUtil'
import Logger from '../common/utils/Logger'
import ItemModel from '../model/ItemModel'
import RecordModel from '../model/RecordModel'
import GroupInfo from '../viewmodel/GroupInfo'
import RecordType from '../viewmodel/RecordType'
import { RecordTypeEnum, recordTypes } from '../viewmodel/RecordTypeModel'
import StatsInfo from '../viewmodel/StatsInfo'

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
      vo.recordItem = ItemModel.getById(po.itemId)
      Logger.debug("po.itemId:"+ItemModel.getById(po.itemId))
      // 2.3.计算热量
      vo.calorie = po.amount * vo.recordItem.calorie
      return vo
    })
  }

  /*
   * 计算统计信息
   * */
  calculateStatsInfo(records: RecordVO[]): StatsInfo {
    let info = new StatsInfo()
    if (!records || records.length <= 0) {
      return info
    }
    records.forEach(r => {
      if (r.typeId === RecordTypeEnum.WORKOUT) {
        // 运动，累加消耗热量
        info.expend += r.calorie
      } else {
        // 食物，累加摄入热量、蛋白质、碳水、脂肪
        info.intake += r.calorie
        info.carbon += r.recordItem.carbon
        info.protein += r.recordItem.protein
        info.fat += r.recordItem.fat
      }
    })
    return info
  }

  /**
   * 将记录列表按照记录类型分组
   * @param records 记录列表
   * @returns 分组记录信息
   */
  calculateGroupInfo(records: RecordVO[]): GroupInfo<RecordType, RecordVO>[] {
    // 1.创建分组
    let groups = recordTypes.map(item => new GroupInfo(item, []))
    if(!records || records.length <= 0){
      return groups
    }
    // 2.遍历所有饮食记录，
    records.forEach(vo => {
      // // 2.1.把每个记录存入其对应类型的分组中
      groups[vo.typeId].items.push(vo)
      // 2.2.计算该组的总热量
      groups[vo.typeId].calorie += vo.calorie
    })
    return groups
  }
}

const service = new RecordService()
export default service as RecordService