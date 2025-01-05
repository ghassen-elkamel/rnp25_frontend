import { Injectable } from "@nestjs/common";
import * as moment from "moment";
import { start } from "repl";

@Injectable()
export class DateService {
  getLesserDate(date1: Date | null, date2: Date | null): Date | null {
    if (date1 && date2) {
      return date1 < date2 ? date1 : date2;
    }

    if (date1) {
      return date1;
    }

    if (date2) {
      return date2;
    }

    return null;
  }
  getGreaterDate(date1: Date | null, date2: Date | null): Date | null {
    if (date1 && date2) {
      return date1 > date2 ? date1 : date2;
    }

    if (date1) {
      return date1;
    }

    if (date2) {
      return date2;
    }

    return null;
  }

  getDuration(startDate: Date, endDate: Date): number {
    const startMoment = moment(startDate);
    const endMoment = moment(endDate);
    const duration = endMoment.diff(startMoment);
    return duration;
  }

  initTimestempMinTime(timestemp: number, offset: number): Date {
    if (!timestemp) {
      return null;
    }
    return this.initDateMinTime(this.adjustForTimeZone(timestemp, offset));
  }
  initDateMinTime(date: Date): Date {
    if (!date) return null;
    let newDate = new Date(date);
    newDate.setHours(0);
    newDate.setMinutes(0);
    newDate.setSeconds(0);
    newDate.setMilliseconds(0);
    return newDate;
  }
  initTimestempMaxTime(timestemp: number, offset: number): Date {
    if (!timestemp) {
      return null;
    }
    return this.initDateMaxTime(this.adjustForTimeZone(timestemp, offset));
  }
  initDateMaxTime(date: Date): Date {
    if (!date) return null;

    let newDate = new Date(date);
    newDate.setHours(23);
    newDate.setMinutes(59);
    newDate.setSeconds(59);
    newDate.setMilliseconds(999);
    return newDate;
  }

  getTodayInterval() {
    return [this.initDateMinTime(new Date()), this.initDateMaxTime(new Date())];
  }

  getIntervalTimstemp(start: number, end: number, timestemp: number) {
    let startDate = this.initTimestempMinTime(start, timestemp);
    let endDate = this.initTimestempMaxTime(end, timestemp);

    startDate ??= this.initDateMinTime(new Date());
    endDate ??= this.initDateMaxTime(new Date());
    return [startDate, endDate];
  }

  adjustForTimeZone(date: number, offsetHours: number) {
    const offsetMilliseconds = offsetHours * 60 * 60 * 1000;
    return new Date(new Date(date).getTime() + offsetMilliseconds);
  }
}
