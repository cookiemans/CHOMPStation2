/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useDispatch, useSelector } from 'common/redux';
import { Button, Collapsible, Divider, Input, Section, Stack } from 'tgui_ch/components'; // CHOMPEdit - tgui_ch
import { moveChatPageLeft, moveChatPageRight, removeChatPage, toggleAcceptedType, updateChatPage } from './actions';
import { MESSAGE_TYPES } from './constants';
import { selectCurrentChatPage } from './selectors';

export const ChatPageSettings = (props, context) => {
  const page = useSelector(context, selectCurrentChatPage);
  const dispatch = useDispatch(context);
  return (
    <Section>
      <Stack align="center">
        <Stack.Item grow={1}>
          <Input
            fluid
            value={page.name}
            onChange={(e, value) =>
              dispatch(
                updateChatPage({
                  pageId: page.id,
                  name: value,
                })
              )
            }
          />
        </Stack.Item>
        {!page.isMain ? (
          <Stack.Item>
            <Button
              icon="times"
              color="red"
              onClick={() =>
                dispatch(
                  removeChatPage({
                    pageId: page.id,
                  })
                )
              }>
              Remove
            </Button>
          </Stack.Item>
        ) : (
          ''
        )}
      </Stack>
      <Divider />
      <Stack align="center">
        {!page.isMain ? (
          <Stack.Item>
            Reorder Chat:&emsp;
            <Button
              color="blue"
              onClick={() =>
                dispatch(
                  moveChatPageLeft({
                    pageId: page.id,
                  })
                )
              }>
              &laquo;
            </Button>
            <Button
              color="blue"
              onClick={() =>
                dispatch(
                  moveChatPageRight({
                    pageId: page.id,
                  })
                )
              }>
              &raquo;
            </Button>
          </Stack.Item>
        ) : (
          ''
        )}
      </Stack>
      <Divider />
      <Section title="Messages to display" level={2}>
        {MESSAGE_TYPES.filter(
          (typeDef) => !typeDef.important && !typeDef.admin
        ).map((typeDef) => (
          <Button.Checkbox
            key={typeDef.type}
            checked={page.acceptedTypes[typeDef.type]}
            onClick={() =>
              dispatch(
                toggleAcceptedType({
                  pageId: page.id,
                  type: typeDef.type,
                })
              )
            }>
            {typeDef.name}
          </Button.Checkbox>
        ))}
        <Collapsible mt={1} color="transparent" title="Admin stuff">
          {MESSAGE_TYPES.filter(
            (typeDef) => !typeDef.important && typeDef.admin
          ).map((typeDef) => (
            <Button.Checkbox
              key={typeDef.type}
              checked={page.acceptedTypes[typeDef.type]}
              onClick={() =>
                dispatch(
                  toggleAcceptedType({
                    pageId: page.id,
                    type: typeDef.type,
                  })
                )
              }>
              {typeDef.name}
            </Button.Checkbox>
          ))}
        </Collapsible>
      </Section>
    </Section>
  );
};
