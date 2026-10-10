import '../../../app/l10n/generated/app_localizations.dart';
import '../domain/entities/german_state.dart';
import '../domain/entities/public_holiday.dart';
import '../domain/entities/school_holiday.dart';

extension PublicHolidayLabel on PublicHoliday {
  String displayName(AppLocalizations l10n) => switch (kind) {
    PublicHolidayKind.newYear => l10n.holidayNewYear,
    PublicHolidayKind.epiphany => l10n.holidayEpiphany,
    PublicHolidayKind.womensDay => l10n.holidayWomensDay,
    PublicHolidayKind.goodFriday => l10n.holidayGoodFriday,
    PublicHolidayKind.easterSunday => l10n.holidayEasterSunday,
    PublicHolidayKind.easterMonday => l10n.holidayEasterMonday,
    PublicHolidayKind.labourDay => l10n.holidayLabourDay,
    PublicHolidayKind.liberationDay => l10n.holidayLiberationDay,
    PublicHolidayKind.ascension => l10n.holidayAscension,
    PublicHolidayKind.whitSunday => l10n.holidayWhitSunday,
    PublicHolidayKind.whitMonday => l10n.holidayWhitMonday,
    PublicHolidayKind.corpusChristi => l10n.holidayCorpusChristi,
    PublicHolidayKind.assumption => l10n.holidayAssumption,
    PublicHolidayKind.childrensDay => l10n.holidayChildrensDay,
    PublicHolidayKind.germanUnity => l10n.holidayGermanUnity,
    PublicHolidayKind.reformation => l10n.holidayReformation,
    PublicHolidayKind.allSaints => l10n.holidayAllSaints,
    PublicHolidayKind.repentance => l10n.holidayRepentance,
    PublicHolidayKind.christmas => l10n.holidayChristmas,
    PublicHolidayKind.boxingDay => l10n.holidayBoxingDay,
  };
}

extension SchoolHolidayLabel on SchoolHolidayPeriod {
  String displayName(AppLocalizations l10n) => switch (kind) {
    SchoolHolidayKind.winter => l10n.schoolHolidayWinter,
    SchoolHolidayKind.midYear => l10n.schoolHolidayMidYear,
    SchoolHolidayKind.carnival => l10n.schoolHolidayCarnival,
    SchoolHolidayKind.spring => l10n.schoolHolidaySpring,
    SchoolHolidayKind.easter => l10n.schoolHolidayEaster,
    SchoolHolidayKind.whitsun => l10n.schoolHolidayWhitsun,
    SchoolHolidayKind.summer => l10n.schoolHolidaySummer,
    SchoolHolidayKind.autumn => l10n.schoolHolidayAutumn,
    SchoolHolidayKind.christmas => l10n.schoolHolidayChristmas,
    SchoolHolidayKind.dayOff => l10n.schoolHolidayDayOff,
  };
}

extension GermanStateLabel on GermanState {
  String displayName(AppLocalizations l10n) => switch (this) {
    GermanState.bw => l10n.stateBw,
    GermanState.by => l10n.stateBy,
    GermanState.be => l10n.stateBe,
    GermanState.bb => l10n.stateBb,
    GermanState.hb => l10n.stateHb,
    GermanState.hh => l10n.stateHh,
    GermanState.he => l10n.stateHe,
    GermanState.mv => l10n.stateMv,
    GermanState.ni => l10n.stateNi,
    GermanState.nw => l10n.stateNw,
    GermanState.rp => l10n.stateRp,
    GermanState.sl => l10n.stateSl,
    GermanState.sn => l10n.stateSn,
    GermanState.st => l10n.stateSt,
    GermanState.sh => l10n.stateSh,
    GermanState.th => l10n.stateTh,
  };
}
