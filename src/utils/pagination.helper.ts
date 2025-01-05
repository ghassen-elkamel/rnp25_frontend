import { ClassConstructor, plainToInstance } from "class-transformer";
import { PageMetaDto } from "src/common/dto/page-meta.dto";
import { PageDto } from "src/common/dto/page.dto";
import { SelectQueryBuilder } from "typeorm";

export function plainToDTOs<T, V>(cls: ClassConstructor<T>, plain: V[]): T[] {
  return plainToInstance(cls, plain, {
    excludeExtraneousValues: true,
  });
}
export function plainToDTO<T, V>(cls: ClassConstructor<T>, plain: V): T {
  return plainToInstance(cls, plain, {
    excludeExtraneousValues: true,
  });
}

export async function getPaginated<Entity, DTO>(
  cls: ClassConstructor<DTO>,
  queryBuilder: SelectQueryBuilder<Entity>,
  pageOptionsDto,
  prefix: string = "",
) {
  let orderByField = "createdAt";
  if (prefix.length > 0) {
    orderByField = prefix + "." + orderByField;
  }
  queryBuilder.orderBy(orderByField, pageOptionsDto.order).offset(pageOptionsDto.skip).limit(pageOptionsDto.take);

  const itemCount = await queryBuilder.getCount();

  const pageMetaDto = new PageMetaDto({ itemCount, pageOptionsDto });

  if (cls) {
    const { entities } = await queryBuilder.getRawAndEntities();
    let data: DTO[] = plainToDTOs(cls, entities);
    return new PageDto(data, pageMetaDto);
  }
  const entities = await queryBuilder.getRawMany();

  return new PageDto(entities, pageMetaDto);
}
